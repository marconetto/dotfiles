command: "/bin/sh pomodoro.widget/showdata.sh"

#Refresh time (default: 1/2 minute 30000)
refreshFrequency: 30000

#Body Style
style: """


  right:50%
  top:04px
  color: #fff
font-family: Droid Sans Mono
  justify-content: center
  align-items: center
  transform: translate(-50%,0%)
  margin-right: 040px


  .container
   height:100px
   width:040px
   text-align:center

  .myspace
   color:#dfbf8e
   font-weight:100
   text-align:center
   font-size: 11px
   font-weight:400
   background: rgba(005, 005, 005, 0.30);
   border: 0.0px solid #666666;
   border-radius: 3px;
   border-top-left-radius: 3px;
   border-top-right-radius: 3px;
   box-shadow: -02px 02px 2px 0px rgba(0,0,0,0.25);


  .text
   font-size: 0em
   color:#fff
   font-weight:100
   margin-top:-0%
   height: 13px

  .myalert
   margin-right:0%


"""

#Render function
#
render: -> """
  <div class="container">
  <div class="myspace">
  <span class="myalert"></span>
  </div>
  </div>

"""

  #Update function
update: (output, domEl) ->

  # name = output.split(' ')

  #DOM manipulation
  $(domEl).find('.myalert').text("#{output}")
  # $(domEl).find('.space').text("#{name[0]}☯◈◆▪#{name[1]}")
  # $(domEl).find('.space').text("#{name[0]}·#{name[1]}")
#  $(domEl).find('.app').text("#{name[1]}")
