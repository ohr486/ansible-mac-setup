        require '/home/ujihisa/git/spawn-for-legacy/lib/sfl'
      
        pid = Kernel.spawn('cat', {:in => File.expand_path('../../README.md', __FILE__)})
        Process.wait(pid)
        
