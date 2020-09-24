# My Used Tech Stuff

deployed endpoint https://used-tech.herokuapp.com/

## **Endpoints**
| Method | URL | Description | Requires Token | Requires Admin |
|--------|-----|-------------|----------------|----------------|
|**register/login** |||||
| POST | /api/auth/register | register a new user |  false | false |
| POST | /api/auth/login | login as existing user | false | false |
|**items** |||||
| POST | /api/items |  | true | true |
| GET | /api/items | gets all items in the database | true | false |
| GET | /api/items/:id | gets item by ID | true | false |
| PUT | /api/items/:id | edit a item | true | true |
| DELETE | /api/items/:id | delete a item | true | true |
| **orders** |||||
| POST | /api/orders | places a new order to the database | true | false |
| GET | /api/orders | returns a list of orders  | true | false |
| GET | /api/orders/:id | gets order by ID | true | false |
| PUT | /api/orders/:id | edit a order | true | true |
## **Table Requirements**
## **Users**
| Name | Type | Required | Unique | Notes |
|------|------|----------|--------|-------|
| id | integer | true | true | auto generated by the API |
| username | string | true | true | - |
| password | string | true | false | - |
| renter | boolean | false | false | determines whether user can create new items, defaults to false  |

# **Items**
| Name | Type | Required | Unique | Notes |
|------|------|----------|--------|-------|
| id | integer | true | true | auto generated by the API |
| user_id | integer | true | false | who the item belongs to |
| name | string | true | false | - |
| rented | boolean | false | false | determines if the item is rented or not, defaults to false  |

# **Orders**
| Name | Type | Required | Unique | Notes |
|------|------|----------|--------|-------|
| id | integer | true | true | auto generated by the API |
| user_id | integer | true | false | who placed the rental order |
| item_id | integer | true | false | what Item is being rented |

## **Login's**
If i need to update the database at any point during the week all users made up until that point will be deleted. These logins will always be available to use.
| username | password | renter |
| ----- | -------- | ---- |
| admin | pass | true |
| user | pass | false |
