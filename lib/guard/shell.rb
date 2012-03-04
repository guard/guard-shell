require 'guard'
require 'guard/guard'

module Guard
  class Shell < Guard
  
    VERSION = '0.2.0'
    
    #
    # @return [Array<Pid>] a list of all the currently active forked processes
    #   that were started as children of this process.
    # 
    def forked_processes
      @forked_processes ||= []
    end
    
    # Execute the command specified in the string
    # 
    # @param [Array<String>] commands to execute
    #
    def run_on_change(commands)
      
      commands.uniq! unless options[:allow_duplicates]
      
      commands.each do |command|
        
        if able_to_fork_process?
          fork command
        else
          system command
        end
        
      end
      
    end

    # 
    # If a number of processes has been specified by the user (enabling forking)
    # and the system is able to generate a forked processes
    # 
    # @return [TrueClass] when the user has requested forking and the system can
    #   handle it.
    # 
    def able_to_fork_process?
      Process.repond_to?(:fork) and options[:max_processes].to_i > 0
    end
    
    
    #
    # @param [String] command to execute within the fork
    #
    def fork(command)

      # If there is room for a forked process then generate a new forked process
      # otherwise wait until any process has finished operation and then re-enqueue
      # this command.

      if forked_processes.length < options[:max_processes]
        forked_processes << Process.fork { Process.exec *command }
      else
        forked_processes.delete Process.wait
        fork command
      end

    end

  end
end