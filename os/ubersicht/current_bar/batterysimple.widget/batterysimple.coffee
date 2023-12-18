command: "/bin/sh batterysimple.widget/showdata.sh"

#Refresh time (default: 1/2 minute 30000)
refreshFrequency: 60000

# .text
#border-bottom: 2.0px solid rgba(255,255,255,.15);


# text-decoration: underline;
# text-decoration-color: #00cccc;
# text-decoration-thickness:  0.8px;
#
#Body Style
style: """

  right:150px
  top:03px
  color: #fff
font-family: Droid Sans Mono
  justify-content: center
  align-items: center
  transform: translate(00%,0%)
  margin-left: 60px


  .container
   right:10px
   height:100px
   width:050px
   text-align:center

   .text
       font-size: 11px
       color:#dfbf8e
       height: 14px
       line-height: 15px
       margin-top:00%
       font-weight:400
       background: rgba(005, 005, 005, 0.30);
       border: 1.0px solid #33333355;
       border-radius: 05px;
       border-top-left-radius: 5px;
       border-top-right-radius: 5px;
       box-shadow: -02px 02px 2px 0px rgba(0,0,0,0.70);






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

  numericPart = output.replace(/[^0-9]/g, '')
  numericNumber = parseInt(numericPart, 10)
  #DOM manipulation
  $(domEl).find('.myspace').text("#{name[0]}")

  if (numericPart < 30)
      $(domEl).find('.myspace').css('color', '#ff5555')
  else
      $(domEl).find('.myspace').css('color', '#dfbf8e')



  # $(domEl).find('.space').text("#{name[0]}·#{name[1]}")
#  $(domEl).find('.app').text("#{name[1]}")
