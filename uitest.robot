*** Settings ***
Library     SeleniumLibrary
Resource    helper.robot

# The following will run for each test case
Test Setup        Begin Web Test
Test Teardown     End Web Test

# The following will run once for the test suite
Suite Teardown    Update Global Test Status

*** Variables ***
${BROWSER} =            chrome
${START_URL} =          https://yellow.co.nz/our-products/search-ads/
${SEARCH_WHAT} =        Cafe
${SEARCH_WHERE} =       Auckland
# remote Selenium grid from LambdaTest
${COMMAND_EXECUTOR}=    https://leo.liang:fL1GyycafGz0bi45KrIsQ9KgZhQ50QoO4VoRzINoC9QUazxIlN@hub.lambdatest.com/wd/hub
# if we want to use our local Selenium Grid just replace the url as http://10.30.20.198:4444/wd/hub

*** Test Cases ***
User can buy online products
    Online Purchase Search Ads Pronduct

#failure case
#    Fail    just fail the test

*** Keywords ***
Begin Web Test
    # open browser  about:blank  ${BROWSER}
    ${options} =     Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${options}   add_argument    headless
    Call Method    ${options}   add_argument    disable-gpu
    Call Method    ${options}   add_argument    no-sandbox
    Call Method    ${options}   add_argument    window-size\=1024,768
    ${caps}    Call Method    ${options}    to_capabilities
    Create Webdriver    Remote    command_executor=${COMMAND_EXECUTOR}    desired_capabilities=${caps}    # remote browser
    #Create Webdriver    Chrome    desired_capabilities=${caps}    # local headless brower
    Go To    ${START_URL}

End Web Test
    Close All Browsers

Online Purchase Search Ads Pronduct
    Wait until element is enabled    Xpath=//a[contains(text(),'get started')]
    Wait Until Keyword Succeeds    5s    1s    Click Element    Xpath=//a[contains(text(),'get started')]
    Sleep    3s
    Capture Page Screenshot