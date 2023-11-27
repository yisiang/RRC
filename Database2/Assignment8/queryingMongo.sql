/* 
	Querying data from MongoDB(MongoDB first release date 2012)
	
	To change MongoDB command prompt to display database@serverServer
	
	modify the .mongorc.js (file located in user home directory) file to include the following
	
	host = db.serverStatus().host;
	prompt = function () {
		return db + "@" + host +" > ";
	}
	
*/

-- use sample_restaurants data provided in cloud(Azure)

-- common commands below
db  						-- will show current database context
show dbs 					-- will show all databases on server
use sample_restaurants 		--these examples will use this database
show collections			-- will display all collections (tables) within DATABASE

-- general syntax
-- db.collection.find()
-- OR 
-- db.collection.find({query}, {projection}) 
/*
	query pertains to the criteria that determines what data is returned. Very similar TO
	the WHERE in a SQL STATEMENT
	
	e.g.
	
	db.inventory.find({status: "Active"});
	
	equivalent of 
	
	SELECT * from inventory WHERE status = "Active"
	
	projection - refers to the columns that get returned to the caller
	
	db.inventory.find({status: "Active"}, {name:1,status:1})
	
	equivalent of 
	
	SELECT name,status FROM inventory where  status="Active"
	
	1 		- displays the COLUMN VALUE
	0 		- suppress the COLUMN VALUE
*/


-- let's find all restaurants in database
-- db.collectionName.find() -- this will search all documents/records within a collection/TABLE
-- SELECT * from restaurants;
db.restaurants.find() 		-- return all restaurants NOTE: this is har to read, lets improve by calling pretty method

db.restaurants.find().pretty() -- NOTE this will format output in easy to read JSON format, note keys are enclosed in quotation marks

-- to find American cuisines
-- SELECT * from restaurants WHERE cuisine = 'American'
db.restaurants.find({cuisine:'American'}).pretty()

-- to find the number of amerian cuisines
-- SELECT count(*) from restaurants where cuisine='American'
db.restaurants.find({cuisine:'American'}).count() -- should return 6183

-- we have been returning the entire document each time we issue find, what if we want to ONLY
-- show a subset of columns from the document in the resultset?
-- SELECT name from restaurants where cuisine='American'
db.restaurants.find({cuisine:'American'},{name: 1}).pretty() -- will show all 6183 documents like before, but only the name this TIME

-- suppress the _id COLUMN ie. not show it in resultset
db.restaurants.find({cuisine:'American'},{name: 1, _id:0 }).pretty()

-- show all 6183 documents but now with two columns/fields - cuisine and name
-- SELECT name,cuisine from restaurants where cuisine='American'
db.restaurants.find({cuisine:'American'},{name: 1, cuisine: 1}).pretty() 

-- sort resultset
-- SELECT name, cuisine from restaurants where cuisine='Amerian' ORDER By name DESC
db.restaurants.find({cuisine:'American'},{name: 1, cuisine: 1}).sort({name: -1}).pretty() -- 1 asc -1 desc


-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Code below uses sample_supplies database, sales collection
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- greater/less than operators
-- $gt 		- greater than 
-- $lt 		- less THAN
-- $gte 	- greater than or equal to
-- $lte 	- less than or equal to

-- IN / NOT IN
-- $in and $nin work on array types or against lists
-- find({field: {$in : val }}, projection)

-- using sample_supplies database 


-- accessing nested documents 

-- accessing a nested document can be done by dot notation to index into KEY
-- here we are indexing into age from customer customer.age
-- SELECT * from sales where age < 50
db.sales.find({"customer.age": {$lt:50}}).pretty() -- return all customers under age 50


-- and and or logical operators
-- NOTE: and and or conditions appear in an array as objects to compare against
-- SELECT * from sales where age < 50 AND gender='F'
db.sales.find({$and: [ {"customer.age": {$lt:50}}, {"customer.gender": "F"} ]}).pretty() -- return all female customers under age 50 

-- SELECT count(*) from sales where ag < 50 and gender='F' total 1568
db.sales.find({$and: [ {"customer.age": {$lt:50}}, {"customer.gender": "F"} ]}).count()  -- count the number of female customers under age 50

-- SELECT * from sales where storeLocation='Seattle' OR storeLocation='San Diego'
-- alternatively
-- SELECT * from sales where storeLocation IN ('Seattle','San Diego')
db.sales.find({$or: [{storeLocation: 'Seattle'}, {storeLocation: 'San Diego'}]}).pretty() -- find all sales in Seattle or San Diego

db.sales.find({$or: [{storeLocation: 'Seattle'}, {storeLocation: 'San Diego'}]}).count() -- find the number of sales in Seattle or San Diego 1480


-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- sample_airbnb DATABASE
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- search for an item in an array
db.listingsAndReviews.find({amenities:  {$all: ['Wifi','Family/kid friendly']}}).pretty() -- works as expected what about nested arrays?
-----------------------------------------------------------------------------------------------------------------


-- index into nested ARRAY
db.sales.find({"items.tags":{$in:["office","school"]}})

/*
 *	
	CREATE a new Datbase for .
	INSERT, UPDATE and DELETE Operations
	
	-- examples of CRUD operators
	db.collection.insertOne()
	db.collection.find()
	db.collection.updateOne()
	db.collection.deleteOne()
	
	use Students
 */
 use Students
 db 	 	-- show database context ie. the database you currently using
 show dbs 	-- not that Students doesn't appear until data is first inserted

 -- insert one document into Students Collection
 db.Students.insertOne({name:'Michael Bialowas', role:'Instructor', age: 28, id:1234})
 show dbs 	-- will now show collection since one student was added
 db.Students.find({}).count() -- show one document or 1 student
 
 -- insert many students into Students Collection
 db.Students.insert([
	{name:'John Duke', role:'Student', age: 18, id:987654},
	{name:'Sam Foster', role:'Student', age: 23, id:555555},
	{name:'Jenny Irving', role:'Student', age: 25, gender:'F', id:222222}
 ])
 -- use of flexible shema
 db.Students.find({}).pretty() -- note use of flexible shema here
 -- document containing Jenny Irving has additional field of gender applied to it
 
 
 -- UPDATE
 -- let's go back and add gender field to John Duke document
 db.Students.updateOne({name:'John Duke'}, {$set: {gender:'M'}})
 db.Students.find({}).pretty()
 
-- let's go back and add gender to remaining documents
-- Michael Bialowas and Sam Foster
db.Students.updateOne(
	{name:'Michael Bialowas'}, {$set: {gender:'M'}}	
) 
db.Students.updateOne(
	{name:'Sam Foster'}, {$set: {gender:'F'}}
)
-- updateMany doesn't appear to work ie. in updating multiple documents in one command

 --- DELETE
 -- let's delete Michael Bialowas 
 db.Students.deleteOne(
	{name:'Michael Bialowas'}	
 )
 
 -- NOTE: Always double check for matching moustache braces {} 
 -- ALot of errors are caused from not having a matching {} braces
 
 
 







 
 
 