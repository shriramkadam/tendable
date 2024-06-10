# Run Webservice
**#Use these steps for running this flask server**  
**#You must have a working python on your machine > 3.10**  

On the command prompt or Terminal  
Step 1: `mkdir tendable`  
Step 2: `cd tendable`  
Step 3: `git clone https://github.com/tendable/mobile-coding-excerise.git` # or unzip the repo  
Step 4: `cd mobile-coding-excerise`  
Step 5: `python -m venv tvenv` # name of virtual environment  
Step 6: `source tvenv/bin/activate`  # On Windows: tvenv\Scripts\activate  
Step 7: `pip install -r requirements.txt`  
Step 8: `python run.py`  

This will launch the server on http://localhost:5001 or http://127.0.0.1:5001. You will see the conect of Readme on the landing page

Please use the API documentation as guidance. It is not necessary that you use all of these to complete the test.

# Endpoints
**Basic Authentication**  
Authentication is not required to access the other endpoints. The following endpoints exist purely as a tool for you to develop the login task.
Note: There is no persistence of registrations between runs of the web server. Every time you stop and run the server again, all the registered users will be lost.

- POST /api/register  
This endpoint registers a user so that it’s later available for the login endpoint. The server expects the JSON to contain an "email" field and a "password" field.  
Example Body:
```json
{
  "email": "johnd@email.com",
  "password": "dogsname2015"
}
```
Returns:  
200 if the registration was successful (both the email and password fields were provided)  
400 if the registration was unsuccessful due to one or both fields missing from the JSON  
401 if the user already exists <br><br>

- POST /api/login  
This endpoint verifies user credentials against already registered users.  
Example Body:
```json
{
  "email": "johnd@email.com",
  "password": "dogsname2015"
}
```
Returns:  
200 if the login was successful (the user was previously registered with the /api/register endpoint)  
400 if the email or password fields are missing from the JSON  
401 if the user does not exist or the credentials are incorrect <br><br>

**Inspections**  
- GET /api/inspections/start  
This endpoint returns a new inspection (no selected answers).  
Note that this endpoint returns the same new inspection every time, except for the inspection id which increments every time the endpoint is called.  
Returns:  
200 with an inspection body attached <br><br>

- POST /api/inspections/submit  
This endpoint expects an inspection JSON body which will be submitted (saved into a file in /inspections at the root of the webserver).  
Note that this endpoint does not do any validation against the JSON format, with the exception of having an inspection object and an id inside the inspection object.  
Returns:  
200 if the inspection was saved  
500 if there was an error (such as the inspection not having an id)  <br><br>

**Other Available Endpoints**  
- GET /api/generate_random_inspections/<count>  
This endpoint generates random inspections that can later be interacted with via other endpoints.  
This is generally expected to be run from the web browser and it only needs to be run once. Subsequent calls to this endpoint will overwrite the previously generated inspections.  
Returns: 200  
Example Usage: localhost:5001/api/generate_random_inspections/10  
This will generate 10 random inspections.

- GET /api/random_inspection  
This endpoint returns a random inspection from the generated inspections, if they have been generated using the endpoint above.  
Returns:  
200 with an inspection body if the inspections have been generated with the generate_random_inspections endpoint  
404 if the inspections have not already been generated  
Example Usage: localhost:5001/api/random_inspection  

- GET /api/inspections/<inspectionId>  
This endpoint returns the inspection with the specified id from the generated inspections, if they have been generated using the endpoint above.  
Returns:  
200 with an inspection body if the inspection was found (was already generated with the generate_random_inspections endpoint, and it wasn’t deleted).  
404 if the inspection could not be found  
Example Usage: localhost:5001/api/inspections/3  

- DELETE /api/inspections/<inspectionId>  
This endpoint deletes an inspection with the specified id, if it exists.  
Returns:  
200 if the inspection was found and deleted successfully  
404 if the inspection could not be found  
Example Usage: localhost:5001/api/inspections/3  

# Models
**Inspection Model**  
Inspection Type Model
```json
{
  "inspectionType": {
    "id": 1,
    "name": "Clinical",
    "access": "write"
  }
}
```

Area Model
```json
{
  "area": {
    "id": 1,
    "name": "Emergency ICU"
  }
}
```

Answer Choice Model  
Note that in the case of Not Applicable answer choices (or N/A), the answer choice id is always -1
```json
{
  "id": 1,
  "name": "Yes",
  "score": 1.0
}
```

Question Model  
Note that the selectedAnswerChoiceId is an optional integer. When this value is null it means that no answer has been selected
```json
{
  "id": 1,
  "name": "Is the drugs trolley locked?",
  "answerChoices": [AnswerChoiceModel],
  "selectedAnswerChoiceId": 1
}
```

Category Model
```json
{
  "id": 1,
  "name": "Drugs",
  "questions": [QuestionModel]
}
```

Survey Model
```json
{
  "id": 1,
  "categories": [CategoryModel]
}
```

Inspection Model
```json
{
  "id": 1,
  "inspectionType": InspectionTypeModel,
  "area": AreaModel,
  "survey": SurveyModel
}
```

Full Inspection Model Example  
This is an example inspection that could be returned by the endpoints.  
When an inspection is returned, it is passed as the value of the ”inspection” key.
```json
{
  "inspection": {
    "id": 1,
    "inspectionType": {
      "id": 1,
      "name": "Clinical",
      "access": "write"
    },
    "area": {
      "id": 1,
      "name": "Emergency ICU"
    },
    "survey": {
      "id": 1,
      "categories": [
        {
          "id": 1,
          "name": "Drugs",
          "questions": [
            {
              "id": 1,
              "name": "Is the drugs trolley locked?",
              "answerChoices": [
                {
                  "id": 1,
                  "name": "Yes",
                  "score": 1.0
                },
                {
                  "id": 2,
                  "name": "No",
                  "score": 0.0
                }
              ],
              "selectedAnswerChoiceId": 1
            }
          ]
        }
      ]
    }
  }
}
```
<br><br>
**Authentication Model**  
The server requires these fields for both the login and register endpoints, however does not perform any validation on the format of the values for these fields.
```json
{
  "email": "johnd@email.com",
  "password": "dogsname2015"
}
```
<br><br>
**Error Model**  
Endpoints can return error codes such as 400, 401, 404. When this happens, a JSON body is attached with an error message.
```json
{
  "error": "Invalid user or password"
}
```
