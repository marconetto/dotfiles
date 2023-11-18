command: "/bin/sh simplealert.widget/showdata.sh"

refreshFrequency: false

#Body Style
style: """


  left:08px
  top:04px
  color: #fff
font-family: Droid Sans Mono

  .container
   right:10px
   height:100px
   width:200px
   text-align:center

  .myspace
   color:#dfbf8e
   font-weight:100
   text-align:center
   font-size: 11px
   margin-top:00%
   font-weight:400
   background: rgba(005, 005, 005, 0.30);
   border: 0.0px solid #666666;
   border-radius: 3px;
   border-top-left-radius: 3px;
   border-top-right-radius: 3px;
   box-shadow: 02px 02px 2px 0px rgba(0,0,0,0.25);


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

update: (output, domEl) ->

  $(domEl).find('.myalert').text("#{output}")
