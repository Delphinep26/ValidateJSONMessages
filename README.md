# Validate JSON Messages task

You have a list containing incoming messages.

All the messages in the list are plain text, but should be with the following JSON format:

{
"transmitter": "abc:123456",
"msg_time": "2019-03-15T10:26:37.951Z",
"msg_type": 83,
"message": "Hello World"
}

Please write a python code that goes over all the messages in the list, and does the following:

1. Make sure the JSON is valid
2. Make sure the transmitter has the following format: “<3 characters>:<numeric value>”
3. Make sure that the message is not older than 7 days
4. Msg type is one of the following (0000,83,84)
5. Messages that pass all validations should be placed in a corresponding list (list per type)
6. Messages that do not pass the validation (or fail for any reason) should be placed in a separate list with the failure reason (text)
  
 Run Solution :
 1. Install requirements.txt
 2. Run validate_JSON_messages.py
 3. Enter filename and ENTER
 4. The 2 outpout files will be created in the current folder
