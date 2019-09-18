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
          
       - Under "ejabberd" is the <module.funtion>: `pkg.installed` means to install the package, watch for service "ejabberd", if it's not running yet, then start it
       - Under "ejabberd.yml" is the <module.function> `file.managed`, we use it to manage configuration to the minions,                - `name` is the directory to apply on the minions 
           - `source` is the directory that contains the file to apply, in this case, `salt://ejabberd/ejabberd.yml` stands for `/srv/salt/ejabberd/ejabberd.yml`
           - `user`, `group` and `mod` are states that apply to the configuration to minions
           - `require` is that state will always execute unless target fails
           - `watch_in` is `watch` that has corresponding requisite_in which is like `require`, but adds additional behaviour, also is requisite state  
   
  - Finally, we apply the "init.sls" file to minions (on this case the target is just minion1 as announced above) using command: `salt 'minion1' state.apply init`, if success, it return like this:
  
      ![](https://github.com/bizflycloud/internship-0719/blob/master/TD_Git/PIC/10.png)
      
 
 
  - Registering an account for Ejabberd:
      - Restart the service, using command :`salt 'minion1' cmd.run "service ejabberd restart"`
      - Create an admin account: `salt 'minion1' cmd.run "ejabberdctl register dungnt 192.168.122.28 dung@456"`, if success, this returns result like:       
      
      ![](https://github.com/bizflycloud/internship-0719/blob/master/TD_Git/PIC/11.png)

      - Login vào Ejabberd theo url: `https://192.168.122.28:5280/admin` because port 5280 for http has been defined and  domain "192.168.122.28" has been defined too. Which will return result: 
      
      ![](https://github.com/bizflycloud/internship-0719/blob/master/TD_Git/PIC/12.png)
      
## Using a XMPP Client to test
  
  - install pidgin
  
  - configure user1 and user2 to connect to server 192.168.122.28
  
  - `ctrl + m` to start a chat conversation
  
  - Here's the result
  
  ![](https://github.com/bizflycloud/internship-0719/blob/master/TD_Git/PIC/13.png)
  
  ![](https://github.com/bizflycloud/internship-0719/blob/master/TD_Git/PIC/14.png)
