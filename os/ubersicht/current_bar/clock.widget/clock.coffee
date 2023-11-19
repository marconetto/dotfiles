command: "pwd ; rm -rf ~/Desktop/*Helper*"


#Refresh time (default: 1/2 minute 30000)
refreshFrequency: 30000

# text-decoration: underline;
# text-decoration-color: #7bb043;
# text-decoration-thickness:  0.8px;

#Body Style
style: """

  right: 80px
  top:03px
  color: #fff
  font-family: Droid Sans Mono
  justify-content: center
  align-items: center
  transform: translate(-00%,0%)


  .container
   right:00px
   width:060px
   height:100px
   text-align:center


  .time
   color:#dfbf8e
   height: 14px
   line-height: 15px
   text-align:center
   font-size: 11px
   margin-top:00%
   font-weight:500

   background: rgba(005, 005, 005, 0.30);
   border: 1.0px solid #33333355;
   border-radius: 05px;
   border-top-left-radius: 5px;
   border-top-right-radius: 5px;
   box-shadow:  -02px 02px 2px 0px rgba(0,0,0,0.70);

  .hour
   margin-right:0%

"""

#Render function
render: -> """
  <div class="container">
  <div class="time">
  <span class="hour"></span>
  </div>
  </div>

"""

  #Update function
update: (output, domEl) ->

  #Options: (true/false)
  showAmPm = true;
  showName = true;
  fourTwenty = false; #Smoke Responsibly
  militaryTime = true; #Military Time = 24 hour time

  days = ['su','mo','tu','we','th','fr','sa'];

  #Grab the name of the current user.
  #If you would like to edit this, replace "output.split(' ')" with your name
  name = output.split(' ')


  #Creating a new Date object
  date = new Date()
  day = date.getDate()
  month = date.getMonth() + 1
  hour = date.getHours()
  minutes = date.getMinutes()
  weekday =  days[date.getDay()]

  #Quick and dirty fix for single digit minutes
  minutes = "0"+ minutes if minutes < 10
  hour = "0"+ hour if hour < 10

  day = "0"+ day if day < 10

  #AM/PM String logic
  if hour < 12
    half = "AM"
  else
    half = "PM"

  #0 Hour fix
  hour= 12 if hour == 0;

  #420 Hour
  if hour == 16 && minutes == 20
    blazeIt = true
  else
    blazeIt = false

  #24 - 12 Hour conversion
  hour = hour%12 if hour > 12 && !militaryTime

  #DOM manipulation
  # if fourTwenty && blazeIt
    # $(domEl).find('.salutation').text("Blaze It")
  # else
  # $(domEl).find('.name').text(" , #{name[0]}.") if showName
  # $(domEl).find('.hour').text("#{hour}:#{minutes}<#{day}")
   # $(domEl).find('.hour').text("#{hour}:#{minutes}")
  # $(domEl).find('.hour').text("#{hour}:#{minutes} #{day}")
  # $(domEl).find('.hour').text("#{hour}:#{minutes}<#{day}")


  # $(domEl).find('.hour').text("#{hour}:#{minutes} ❘ #{day}")
  # $(domEl).find('.hour').text("#{hour}:#{minutes} ❘ #{day}#{weekday}")
  #
  # $(domEl).find('.hour').text("#{hour}:#{minutes}·#{day}")
  # $(domEl).find('.hour').text("#{hour}:#{minutes}·#{day}")
  # $(domEl).find('.hour').text("#{hour}:#{minutes}≡#{day}")
  # $(domEl).find('.hour').text("#{hour}:#{minutes}︲#{day}")
  # $(domEl).find('.hour').text("#{hour}:#{minutes}〡#{day}")

  # $(domEl).find('.hour').text("#{hour}:#{minutes} · #{day}")
  $(domEl).find('.hour').html("#{hour}:#{minutes}")


  if (minutes >= 55)
      $(domEl).find('.hour').css('color', '#ff5555')
  # $(domEl).find('.hour').html("⏲ #{hour}:#{minutes}")
  # $(domEl).find('.hour').html("⏲ #{hour}:#{minutes}")
  # $(domEl).find('.hour').html("#{hour}:#{minutes} &nbsp; #{day}-#{weekday}")


  # $(domEl).find('.hour').text("#{hour}:#{minutes}┃#{day}")
  # $(domEl).find('.hour').text("#{day} #{hour}:#{minutes}")
  # $(domEl).find('.hour').text("#{day}·#{hour}:#{minutes}")
 # $(domEl).find('.min').text("#{minutes}")
  # $(domEl).find('.half').text("#{half}") if showAmPm && !militaryTime
