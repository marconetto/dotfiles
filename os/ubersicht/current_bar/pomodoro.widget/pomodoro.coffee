command: "/bin/sh pomodoro.widget/showdata.sh"

#Refresh time (default: 1/2 minute 30000)
refreshFrequency: 30000

#Body Style
style: """


  left:010px
  top:03px
  color: #fff
  font-family: Droid Sans Mono
  justify-content: center
  align-items: center
  transform: translate(-00%,0%)


  .container
   right:00px
   width:050px
   height:100px
   text-align:center

  .myspace
   color:#dfbf8e
   font-weight:100
   text-align:center
   line-height: 15px
   height:14px
   font-size: 11px
   font-weight:400
   background: rgba(005, 005, 005, 0.30);
   border: 1.0px solid #33333355;
   border-radius: 05px;
   border-top-left-radius: 5px;
   border-top-right-radius: 5px;
   box-shadow: 02px 02px 2px 0px rgba(0,0,0,0.70);


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


   output = output.trim()
   if ( output == "DONE" )
      $(domEl).find('.myalert').text("#{output}")
      $(domEl).find('.myalert').css('color', '#ff5555')
      # $(domEl).find('.myalert').css('font-weight', 'regular')
   else
     $(domEl).find('.myalert').text("#{output}")

  # name = output.split(' ')

  #DOM manipulation
  # $(domEl).find('.myalert').text("#{output}")
  # $(domEl).find('.space').text("#{name[0]}☯◈◆▪#{name[1]}")
  # $(domEl).find('.space').text("#{name[0]}·#{name[1]}")
#  $(domEl).find('.app').text("#{name[1]}")
