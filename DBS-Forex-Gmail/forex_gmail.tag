// This automation flow gets forex rates from DBS.com
// and sends a csv file of the forex rates using Gmail. 
// The Gmail portion was done on macOS Chrome at 100% zoom,
// 2 images may have to be replaced with your browser's to work.

// visit DBS website with a table of foreign currency exchange rates
https://www.dbs.com.sg/personal/rates-online/foreign-currency-foreign-exchange.page

// define list of currencies to retrieve their exchange rates
currencies = ['USD', 'EUR', 'GBP', 'JPY', 'HKD', 'CNY']

// create a blank csv file with the header row containing 2 columns
dump Currency,Rate to numbers.csv

// process currency conversions based on list of currencies
for n from 0 to currencies.length-1
    
    // click on the dropdown before selecting item from dropdown list
    // this is a non-standard dropdown list, select step not applicable
    click currToSelectId
    
    // XPath is a powerful way to identify webpage UI elements
    // intro to XPath - https://builtvisible.com/seo-guide-to-xpath
    click //*[@id = 'targetUl']//*[text() = '`currencies[n]`']
    
    // clear the field and type 1 to calculate exchange rate
    // the toggle button method is trickier for THB, JPY etc
    type currToInputId as [clear]1
    
    // read converted currency value in SGD
    read currFromInputId to rate
    
    // show the forex rate as it is being extracted
    echo 1 `currencies[n]` to S$`rate`
    
    // save current row of forex rate to the csv file
    // by using csv_row() function on an array of fields
    forex_rate = [currencies[n] + 'SGD', 'S$' + rate]
    write `csv_row(forex_rate)` to numbers.csv

// increase timeout from default 10 seconds to 60 seconds,
// to let user sign in to Gmail if it is not yet signed in
timeout 60 seconds

// Gmail is used here to send email, but desktop apps such as Outlook
// can also be used by providing image snapshots of their UI elements.
// To use image snapshots here, set browser to 125% zoom while at Gmail.
// (Chrome was set at 125% zoom for this workflow to show actions clearly)
https://mail.google.com/mail/u/0/

// set focus to Chrome browser and compose a new message
//click chrome_icon.png
//click gmail_compose.png
click Compose

// fill up different fields in the new message window
// change to your email address to test this workflow
//type gmail_to.png as email@your_domain.com
// Recipient
type //textarea[@name="to"] as slscgbot@gmail.com[enter]
//enter gmail_body.png as Hi Boss,[enter][enter]Attached are the forex rates for today.[enter][enter]Regards,[enter]Ken
click /html[1]/body[1]/div[23]/div[1]/div[1]/div[1]/div[1]/div[3]/div[1]/div[1]/div[1]/div[1]/div[1]/div[3]/div[1]/div[1]/div[4]/table[1]/tbody[1]/tr[1]/td[2]/table[1]/tbody[1]/tr[1]/td[1]/div[1]/div[1]/div[2]/div[1]/div[1]/table[1]/tbody[1]/tr[1]/td[2]/div[2]/div[1]
type /html[1]/body[1]/div[23]/div[1]/div[1]/div[1]/div[1]/div[3]/div[1]/div[1]/div[1]/div[1]/div[1]/div[3]/div[1]/div[1]/div[4]/table[1]/tbody[1]/tr[1]/td[2]/table[1]/tbody[1]/tr[1]/td[1]/div[1]/div[1]/div[2]/div[1]/div[1]/table[1]/tbody[1]/tr[1]/td[2]/div[2]/div[1] as Hi Boss,[enter][enter]Attached are the forex rates for today.[enter][enter]Regards,[enter]Ken
//type gmail_subject.png as Daily Forex Rates
// Subject
type //input[@name="subjectbox"] as Daily Forex Rates

// attach csv file of forex rates and send the email
// (assume current folder is at the workflow location)
//click gmail_attach.png
click Attach files
vision Settings.AlwaysResize = 0.5
click numbers_icon_lookang.png
click gmail_open_lookang.png

// wait a while to make sure csv file has been uploaded
wait 5 seconds
//click gmail_send.png
// Send Button
click //div[@role="button"][contains(@data-tooltip, "Send")]
// Schedule tommorow morning
//click G-asx
//click J-N yr
//click Tomorrow morning 
// wait for some time to see the email in your inbox
wait 15 seconds

// In normal situations, Chrome must be set at 100% zoom for TagUI to work.
// Because TagUI replicates mouse clicks at the x,y coordinates of elements.
// Here, visual automation method is used, thus 125% zoom works for Gmail.

// Workflows can be scheduled to run periodically as required.
// Eg using task scheduler on Windows or crontab on macOS & Linux
// to schedule outside of office hours or on a dedicated computer.
