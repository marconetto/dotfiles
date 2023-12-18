command: "/bin/sh appspace.widget/showdata.sh"

#Refresh time (default: 1/2 minute 30000)
refreshFrequency: false


# text-decoration: underline;
# text-decoration-color: #edc951;
 # text-decoration-thickness:  0.8px;

     # border-bottom: 1.0px solid #8b7782;
#Body Style
style: """

  left:50%
  top:04px
  color: #fff
font-family: Droid Sans Mono
  justify-content: center
  align-items: center
  transform: translate(50%,0%)
  margin-left: 110px



  .container
   right:10px
   height:100px
   width:040px
   text-align:center

  .text
     font-size: 11px
     color:#dfbf8e
     height: 14px
     line-height: 15px
     margin-top:00%
     font-weight:400
     background: rgba(005, 005, 005, 0.30);
     border-radius: 3px;
     border-top-left-radius: 3px;
     border-top-right-radius: 3px;
     box-shadow: -02px 02px 2px 0px rgba(0,0,0,0.25);


"""

#Render function
render: -> """
  <div class="container">
  <div class="text">
  <span class="myspace"></span>
  <span class="app"></span>
  </div>
  </div>

"""

  #Update function
update: (output, domEl) ->

  name = output.split(' ')

  #DOM manipulation
  $(domEl).find('.myspace').text("#{name[0]}·#{name[1]}")
  # $(domEl).find('.myspace').text("#{name[0]}≡#{name[1]}")
  # $(domEl).find('.space').text("#{name[0]}☯◈◆▪#{name[1]}")
  # $(domEl).find('.space').text("#{name[0]}·#{name[1]}")
#  $(domEl).find('.app').text("#{name[1]}")
