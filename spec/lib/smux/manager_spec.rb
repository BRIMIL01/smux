require_relative "../../../lib/smux/manager"

describe Smux::Manager do
  describe ".configure" do

    context "when given a configuration block" do
      it "yields the configuration block"
    end

    context " when given an options hash" do
      context "when shell command is passed in options" do
        it "sets the command option"
      end
      context "when config file is passed in options" do
        it "sets the config file option"
      end
    end
  end

  describe ".session" do
    context "when given a session name" do
      it "creates a new session"

      context "when given a session block" do
        it "yields the session block"
      end
    end

    context "when not given a session name" do
      it "returns an error"
    end
  end

  describe ".window" do
  end
end