(function () {
  console.log('down, hound!')
  const timelineItems = document.querySelectorAll('.js-timeline-item')
  console.log('timelineItems', timelineItems)
  const houndItems = [].filter.call(timelineItems, item => {
    return item.innerText.toLowerCase().startsWith('houndci-bot')
  })
  console.log('houndItems', houndItems)
  const houndResolveButtons = [].map.call(houndItems, item => {
    const allButtons = item.querySelectorAll('button')
    return [].filter.call(allButtons, button => {
      return button.innerText.toLowerCase().startsWith('resolve')
    })
  })
  window.houndResolveButtons = houndResolveButtons
  console.log('houndResolveButtons', houndResolveButtons)
  ;[].forEach.call(houndResolveButtons, (resolveButtons, index) => {
    console.log('resolving hound item:', houndItems[index])
    ;[].forEach.call(resolveButtons, button => {
      console.log('hitting resolve button:', button)
      button.click()
    })
  })
  return true
})()
