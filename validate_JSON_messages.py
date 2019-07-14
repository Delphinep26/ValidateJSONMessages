import json
import jsonschema
import datetime

def validate_date_period(msgtime):
    #check if the message is not older than 7 days else raise Error
    try:
        date = datetime.datetime.strptime(msgtime[:10], '%Y-%m-%d')
    except ValueError:
        raise jsonschema.exceptions.ValidationError("Incorrect date format")
        
    today = datetime.datetime.now()
    delta = today - date
    if delta.days > 7 :
        raise jsonschema.exceptions.ValidationError("the message should not be older than 7 days")
    return True


def validate_data(message,schema):
    jsonschema.validate(instance=message, schema=schema)
    validate_date_period(message['msg_time'])
    return True


def update_output_data(data,data_key,message):
    if data_key not in data.keys():
        data[data_key] = []
    return data[data_key].append(message)


def write_data_to_file(data,filename):
    if data:
        with open(filename,'w') as f:
            for key, val in data.items():
                f.write(str(key) + " : " + str(val) + "\n")
        f.close()

def main():

    file_name = input("Please enter filename: ")

    #init
    validated_messages = {}
    not_validated_messages = {}

    schema = {"type": "object",
              "properties": {
                    "transmitter": {"type": "string","pattern": "^[a-z][a-z][a-z][:][0-9]+"},
                    "msg_time": {"type": "string","format": "date-time"},
                    "msg_type": {"type": "number", "enum": [83, 84, 000]},
                    "message": {"type": "string"}
               }
              }
    #Open and read file
    try :
        with open(file_name) as json_file:
            data = json_file.read()
            new_data = data.replace('}{', '},{')
            list_message = list(json.loads(f'[{new_data}]'))
            #Validate and save data in the correspond list
            for message in list_message:
                try:
                    validate_data(message,schema)
                    data_key = message['msg_type']
                    update_output_data(validated_messages, data_key, message)

                except jsonschema.exceptions.ValidationError as e:
                    data_key = e.message
                    update_output_data(not_validated_messages,data_key, message)
        #Write result to file
        write_data_to_file(validated_messages,'output_valid.txt')
        write_data_to_file(not_validated_messages, 'output_not_valid.txt')
    except FileNotFoundError as e :
        print("File not found")


if __name__ == '__main__':
    main()

