module SystemCheck
  module App
    class RubyVersionCheck < SystemCheck::BaseCheck
      set_name -> { "Ruby version >= #{self.required_version} ?" }
      set_check_pass -> { "yes (#{self.current_version})" }

      def self.required_version
        @required_version ||= Gitlab::VersionInfo.new(2, 3, 3)
      end

      def self.current_version
        @current_version ||= Gitlab::VersionInfo.parse(Gitlab::TaskHelpers.run_command(%w(ruby --version)))
      end

      def check?
        self.class.current_version.valid? && self.class.required_version <= self.class.current_version
      end

      def show_error
        try_fixing_it(
          "Update your ruby to a version >= #{self.class.required_version} from #{self.class.current_version}"
        )
        fix_and_rerun
      end
    end
  end
end
