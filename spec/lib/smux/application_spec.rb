require_relative "../../../lib/smux/application"

describe Smux::Application do
  describe ".new" do
    context "when path to .smux.rb is provided" do
      it "assigns dot_smux_rb_path to the given path" do
        app = Smux::Application.new('/path/to/dot_smux_rb')
        app.instance_variable_get("@dot_smux_rb_path").should == '/path/to/dot_smux_rb'
      end
    end

    context "when path to .smux.rb is NOT provided" do
      it "assigns dot_smux_rb_path to nil" do
        app = Smux::Application.new
        app.instance_variable_get("@dot_smux_rb_path").should be_nil
      end
    end
  end

  describe "#run" do
    context "when .smux.rb path is given" do
      let(:app) { Smux::Application.new('/some/path/to/dot_smux.rb') }

      it "loads the specified .smux.rb" do
        app.should_receive(:load_smux_rb).with('/some/path/to/dot_smux.rb')
        app.run
      end
    end

    context "when .smux.rb path is NOT given" do
      let(:app) { Smux::Application.new }

      it "searches for a .smux.rb file" do
        Smux::Putter.stub(:error)
        app.stub(:load_smux_rb)
        app.should_receive(:find_smux_rb)
        app.run
      end

      context "when the search finds a .smux.rb file" do
        before(:each) do
          app.stub(:find_smux_rb).and_return('/path/to/dot_smux.rb')
        end

        it "loads the discovered .smux.rb file" do
          Smux::Putter.stub(:error)
          app.should_receive(:load_smux_rb).with('/path/to/dot_smux.rb')
          app.run
        end

        context "when loading the discovered .smux.rb file throws an exception" do
          before(:each) do
            @exception = Exception.new('Some exception')
            app.stub(:load_smux_rb).and_raise(@exception)
          end

          it "outputs error message saying .smux.rb load failed" do
            Smux::Putter.stub(:exception)
            Smux::Putter.should_receive(:error).with("Failed to load .smux.rb file!")
            app.run
          end

          it "outputs the exception and backtrace to help the user resolve the issue in their .smux.rb" do
            Smux::Putter.stub(:error)
            Smux::Putter.should_receive(:exception).with(@exception)
            app.run
          end

          it "returns the exit code identifying success" do
            Smux::Putter.stub(:exception)
            Smux::Putter.stub(:error)
            app.run.should == Smux::Errors::LOAD_SMUXRB_FAILED
          end
        end

        context "when loading the discovered .smux.rb file does NOT throw an exception" do
          it "returns the exit code identifying success" do
            app.stub(:load_smux_rb)
            app.run.should == Smux::Errors::SUCCESS
          end
        end
      end

      context "when the search fails to find a .smux.rb file" do
        before(:each) do
          app.stub(:find_smux_rb).and_return(nil)
        end

        it "notifies the user it couldn't find a .smux.rb file" do
          Smux::Putter.should_receive(:error)
          app.run
        end

        it "it returns the exit code identifying failure in finding a .smux.rb" do
          Smux::Putter.stub(:error)
          app.run.should == Smux::Errors::FAILED_TO_FIND_SMUXRB
        end
      end
    end
  end

  describe "#load_smux_rb" do
    it "requires the .smux.rb file"
  end

  describe "#find_smux_rb" do
    it "checks if CWD/.smux.rb exists" do
      Dir.stub(:getwd).and_return('/some/cwd')
      File.should_receive(:exists?).with('/some/cwd/.smux.rb')
      subject.send(:find_smux_rb)
    end

    context "when CWD/.smux.rb exists" do
      before(:each) do
        File.stub(:exists?).and_return(true)
      end

      it "returns the path to .smux.rb if found" do
        Dir.stub(:getwd).and_return('/some/cwd')
        subject.send(:find_smux_rb).should == '/some/cwd/.smux.rb'
      end
    end

    context "when CWD/.smux.rb does NOT exist" do
      before(:each) do
        File.stub(:exists?).and_return(false)
      end

      it "returns nil if it fails to find a .smux.rb" do
        Dir.stub(:getwd).and_return('/some/cwd')
        subject.send(:find_smux_rb).should be_nil
      end
    end
  end
end
