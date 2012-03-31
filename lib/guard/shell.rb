require 'guard'
require 'guard/guard'

module Guard
  class Shell < Guard
  
    VERSION = '0.1.1'

    def start
      run_all
    end

    def run_all
      run_on_change([options[:run_all].call]) if options[:run_all]
    end

    # Print the result of the command, if there is a result
    # to be printed. (see README.md)
    #
    # @param res [Array] the result of the commands that have run
    #
    def run_on_change(res)
      UI.info res[0] if res[0]

      notify(res[0], $?)
    end

    # @param message [String] shell output
    # @param status [Process::Status] process exit status
    def notify(message, status)
      if status && status.pid != @last_pid
        @last_pid = status.pid
        if status.exitstatus == 0
          ::Guard::Notifier.notify(message || "Success", :title => 'Shell results', :image => :success)
        else
          ::Guard::Notifier.notify(message || "Failed", :title => 'Shell results', :image => :failed)
        end
      end
    end

  end
end
