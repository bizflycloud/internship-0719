# Salt State plays two main roles, which are Remote Execute and Configuration management

## Remote Execute
  
  - By using: `salt 'target' cmd.run 'command'` we can officially run command to a target
  
## Configuration management

  - Salt states are described using YAML, which is a simple language for describing structured data (similar to JSON, but more human friendly).
  
  - State declaration:
    - ID: a String describe state, must be unique
      - Module.function : Module and function that you want to call  
        - Arguements
    
    The first line in a Salt state declaration is the ID. Underneath the ID is where you call one or more Salt state functions.
    
## Using Salt to setup and config eJabberd to minions, in this scheme, we apply on `minion1`

  On *SALT MASTER:*

  - First we use command :`vim /etc/salt/master` and find "base" and then uncomment lines in `file_roots`. The goal of this action is to provides an "base" environment that can contain states files
  
  ![](https://github.com/bizflycloud/internship-0719/blob/master/TD_Git/PIC/9.png)
  
  - Secondly, we provides an YML file, which is specified as "ejabberd.yml", in that file we modify the custom configuration as we want to apply to minions
      
      You can see the configuration option of ejabberd in doc from Ejabberd or in SaltStack Fomular git repository
      
      Click to view [ejabberd.yml](https://github.com/bizflycloud/internship-0719/blob/master/TD_Git/ejabberd.yml)
    
      We create this YML file in `/srv/salt/ejabberd/`
  
  - Thirdly, we define an SLS file calls "init" to apply the configuration in the YML file to minions
    
      The `init.sls` file is created in `/srv/salt/` because of its "base" evironment
      
      Click to view [init.sls](https://github.com/bizflycloud/internship-0719/blob/master/TD_Git/init.sls)
      
      We give it 2 IDs: "ejabberd" and "ejabberd.yml"
          
          Under "ejabberd" is the module.funtion: `pkg.installed:`
