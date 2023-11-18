command: "/bin/sh net.widget/showdata.sh"
# command: "finger `whoami` | awk -F: '{ print $3 }' | head -n1 | sed 's/^ // '"


#Refresh time (default: 1/2 minute 30000)
refreshFrequency: 30000

# text-decoration: underline;
# text-decoration-color: #7bb043;
# text-decoration-thickness:  0.8px;

# --> .myspace
#   border-bottom: 2.0px solid rgba(255,255,255,.15);

#Body Style
style: """

  left:50%
  top:04px
  color: #fff
font-family: Droid Sans Mono
  justify-content: center
  align-items: center
  transform: translate(50%,0%)
  margin-left: 140px



  .container



  .myspace
   right:10px
   width:40px
   color:#dfbf8e
   text-align:center
   font-size: 11px
   font-weight: 400
   height: 14px
   line-height: 15px
   background: rgba(005, 005, 005, 0.30);
   border: 0.0px solid #666666;
   border-radius: 3px;
   border-top-left-radius: 3px;
   border-top-right-radius: 3px;
   box-shadow: -02px 02px 2px 0px rgba(0,0,0,0.25);

"""


#Render function
render: -> """
  <div class="myspace">
  <span class="mynet"></span>
  </div>

"""

  #Update function
update: (output, domEl) ->

  name = output.split(' ')

  #DOM manipulation
  $(domEl).find('.mynet').text("#{name[0]}")
  # $(domEl).find('.space').text("#{name[0]}☯◈◆▪#{name[1]}")
  # $(domEl).find('.space').text("#{name[0]}·#{name[1]}")
#  $(domEl).find('.app').text("#{name[1]}")
