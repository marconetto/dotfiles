export const refreshFrequency = false // ms

const theme = {
  borderSize: 20,
  thickness: '3.2px',
  screenSize: 100
}

const getBarStyle = () => {
  const height = theme.thickness
  const background = '#dddddd'
  const borderSize = theme.borderSize

  return {
    top: 18,
    right: 0,
    width: 0,
    position: 'fixed',
    background,
    height,
  }
}

export const command=`bash kbswitcher.widget/script.sh`
export const render = ({ output, error }) => {

  const barStyle = getBarStyle()

 if (output.includes("BR")) {

    barStyle.background = '#FF7777'
    barStyle.width = 18
 }

  return (
      <div style={barStyle}> </div>
  )
}
