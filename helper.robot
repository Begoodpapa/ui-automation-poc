*** Settings ***
Library    String

*** Variables ***
${AWS_CODE_BUID_ID}    %{CODEBUILD_BUILD_ID}    #AWS codebuild job has a environmental variable $CODEBUILD_BUILD_ID

*** Keywords ***
Create Global Variable For Overall Test Result
    Set Global Variable    ${GLOBAL_TEST_STATUS}    "success"    # the global variable indicates the overall test result(success/failure) of all test suites

Update Global Test Status
    ${var_existing}=    Run keyword and return status    Variable Should Exist    ${GLOBAL_TEST_STATUS}
    Run keyword unless    ${var_existing}    Create Global Variable For Overall Test Result    # this keyword should be only called for 1st test suite while the varaible is not created
    ${curr_global_test_status}=    Set Variable    ${GLOBAL_TEST_STATUS}

    ${GLOBAL_TEST_STATUS}=    Set Variable If
    ...    '${SUITE STATUS}'=='FAIL'    "failure"    #  ${SUITE STATUS} is an automatic variable indicates the status of the current test suit
    ...    '${SUITE STATUS}'=='PASS'    ${curr_global_test_status} 
    Set Global Variable    ${GLOBAL_TEST_STATUS}
    #Log    ${GLOBAL_TEST_STATUS}

Get S3 Folder Names From Codebuild ID
    [Documentation]    AWS codebuild job has a environmental variable $CODEBUILD_BUILD_ID, which has the build name as the prefix
    ...   echo $CODEBUILD_BUILD_ID 
    ...   UI_automation_PoC:922922e2-1f10-45ea-919e-a72bf3672d9f 
    ...   return value of this keyword is 922922e2-1f10-45ea-919e-a72bf3672d9f in upper exmaple
    ${length}=    Get Length    ${AWS_CODE_BUID_ID}
    : FOR   ${i}    IN RANGE    0   ${length}
    \   Log     ${AWS_CODE_BUID_ID[${i}]}
    \   Exit for loop if    '${AWS_CODE_BUID_ID[${i}]}'==':'
    ${code_build_id}=    Get Substring    ${AWS_CODE_BUID_ID}    ${i+1}
    ${code_build_task_name}=    Get Substring    ${AWS_CODE_BUID_ID}    0    ${i}
    #Log Many    ${code_build_id}    ${code_build_task_name}
    [return]    ${code_build_id.strip()}    ${code_build_task_name.strip()}
