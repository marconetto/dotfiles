command: "pwd ; rm -rf ~/Desktop/*Helper*"


#Refresh time (default: 1/2 minute 30000)
refreshFrequency: 30000

# text-decoration: underline;
# text-decoration-color: #7bb043;
# text-decoration-thickness:  0.8px;

#Body Style
style: """

  left: 50%
  top:04px
  color: #fff
  font-family: Fira Code
  justify-content: center
  align-items: center
  transform: translate(-50%,0%)



  .container
   right:00px
   width:100px
   text-align:center


  .time
   color:#dfbf8e
   height: 14px
   line-height: 15px
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
   box-shadow:  -02px 02px 2px 0px rgba(0,0,0,0.25);

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

  #Time Segmends for the day
  segments = ["morning", "afternoon", "evening", "night"]

  #Grab the name of the current user.
  #If you would like to edit this, replace "output.split(' ')" with your name
  name = output.split(' ')


  #Creating a new Date object
  date = new Date()
  day = date.getDate()
  month = date.getMonth() + 1
  hour = date.getHours()
  minutes = date.getMinutes()

  #Quick and dirty fix for single digit minutes
  minutes = "0"+ minutes if minutes < 10
  hour = "0"+ hour if hour < 10

  day = "0"+ day if day < 10
  #timeSegment logic
  timeSegment = segments[0] if 4 < hour <= 11
  timeSegment = segments[1] if 11 < hour <= 17
  timeSegment = segments[2] if 17 < hour <= 24
  timeSegment = segments[3] if  hour <= 4

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
    # $(domEl).find('.salutation').text("Good #{timeSegment}")
  # $(domEl).find('.name').text(" , #{name[0]}.") if showName
  # $(domEl).find('.hour').text("#{hour}:#{minutes}<#{day}")
   # $(domEl).find('.hour').text("#{hour}:#{minutes}")
  # $(domEl).find('.hour').text("#{hour}:#{minutes} #{day}")
  # $(domEl).find('.hour').text("#{hour}:#{minutes}<#{day}")

  $(domEl).find('.hour').text("#{hour}:#{minutes}")
  # $(domEl).find('.hour').text("#{hour}:#{minutes}·#{day}")
  # $(domEl).find('.hour').text("#{hour}:#{minutes}·#{day}")
  # $(domEl).find('.hour').text("#{hour}:#{minutes}≡#{day}")
  # $(domEl).find('.hour').text("#{hour}:#{minutes}︲#{day}")
  # $(domEl).find('.hour').text("#{hour}:#{minutes}〡#{day}")

  # $(domEl).find('.hour').text("#{hour}:#{minutes}·#{day}")
  # $(domEl).find('.hour').text("#{hour}:#{minutes}┃#{day}")
  # $(domEl).find('.hour').text("#{day} #{hour}:#{minutes}")
  # $(domEl).find('.hour').text("#{day}·#{hour}:#{minutes}")
 # $(domEl).find('.min').text("#{minutes}")
  # $(domEl).find('.half').text("#{half}") if showAmPm && !militaryTime
