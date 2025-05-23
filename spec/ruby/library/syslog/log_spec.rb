require_relative '../../spec_helper'

platform_is_not :windows do
  require 'syslog'

  describe "Syslog.log" do
    platform_is_not :windows, :darwin, :aix, :android do

      before :each do
        Syslog.opened?.should be_false
      end

      after :each do
        Syslog.opened?.should be_false
      end

      it "receives a priority as first argument" do
        -> {
          Syslog.open("rubyspec", Syslog::LOG_PERROR) do |s|
            s.log(Syslog::LOG_ALERT, "Hello")
            s.log(Syslog::LOG_CRIT, "World")
          end
        }.should output_to_fd(/\Arubyspec(?::| \d+ - -) Hello\nrubyspec(?::| \d+ - -) World\n\z/, $stderr)
      end

      it "accepts undefined priorities" do
        -> {
          Syslog.open("rubyspec", Syslog::LOG_PERROR) do |s|
            s.log(1337, "Hello")
          end
          # use a regex since it'll output unknown facility/priority messages
        }.should output_to_fd(/rubyspec(?::| \d+ - -) Hello\n\z/, $stderr)
      end

      it "fails with TypeError on nil log messages" do
        Syslog.open do |s|
          -> { s.log(1, nil) }.should raise_error(TypeError)
        end
      end

      it "fails if the log is closed" do
        -> {
          Syslog.log(Syslog::LOG_ALERT, "test")
        }.should raise_error(RuntimeError)
      end

      it "accepts printf parameters" do
        -> {
          Syslog.open("rubyspec", Syslog::LOG_PERROR) do |s|
            s.log(Syslog::LOG_ALERT, "%s x %d", "chunky bacon", 2)
          end
        }.should output_to_fd(/rubyspec(?::| \d+ - -) chunky bacon x 2\n\z/, $stderr)
      end
    end
  end
end
