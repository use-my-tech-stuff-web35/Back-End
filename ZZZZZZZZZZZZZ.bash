npm i
npm init -y
npm i bcryptjs chalk cors cross-env dotenv express helmet jsonwebtoken knex pg sqlite3 supertest
npm i -D nodemon
npx gitignore node
knex init
mkdir data router auth
touch index.js server.js data/db-config.js router/router.js router/helper.js Z_REQUIRED_EDITS.md

printf 'const knex = require("knex");

const config = require("../knexfile.js");

const environment = process.env.DB_ENV || "development";

module.exports = knex(config[environment]);' >> data/db-config.js

echo "DONE========================================================"

printf "require('dotenv').config()
const server = require('./server')
const chalk = require('chalk')

const PORT = process.env.PORT || 5000

server.listen(PORT, () => {
  console.log(chalk.blue(\` >> [Port \${PORT}] I'm listening...\`))
})" >> index.js

echo "DONE========================================================"

printf 'const express = require("express")
const helmet = require("helmet")
const cors = require("cors")

const authRouter = require("./auth/auth-router")
const usersRouter = require("./router/router")
const restricted = require("./auth/restricted-middleware")


const server = express()

server.use(helmet())
server.use(express.json())
server.use(
    cors({
        origin: "*",
        credentials: true,
    })
)

server.use("/api/auth", authRouter)
server.use("/api/users", usersRouter)

server.get("/", (req, res) => {
    res.status(200).json({ Victor_Frankenstein: "Its ALIVE!!!!!!" })
})

module.exports = server' >> server.js

echo "DONE========================================================"

printf "const router = require('express').Router()

const helper= require('./helper') 
const restricted = require('../auth/restricted-middleware')

router.get('/', (req, res) => {
  helper.find('TABLE')
  .then(rez => res.status(200).json(rez))
  .catch(err => res.status(500).json({status: 500, err}))
})

router.get('/:id', (req, res) => {
  const id = req.params.id
  helper.findById(id, 'TABLE')
  .then(rez => res.status(200).json(rez))
  .catch(err => res.status(500).json({status: 500, err}))
})

router.post('/', (req, res) => {
  helper.add(req.body, 'TABLE')
  .then(rez => res.status(200).json(rez))
  .catch(err => res.status(500).json({status: 500, err}))
})

router.put('/:id', (req, res) => {
  const id = req.params.id
  helper.update(req.body, id, 'TABLE')
  .then(rez => res.status(200).json(rez))
  .catch(err => res.status(500).json({status: 500, err}))
})

router.delete('/:id', (req, res) => {
  const id = req.params.id
  helper.remove(id, 'TABLE')
  .then(rez => res.status(200).json(rez))
  .catch(err => res.status(500).json({status: 500, err}))
})

function checkRole(role) {
  return (req, res, next) => {
    if (req.jwt.role === role) {
      next();
    } else {
      res.status(403).json({ message: 'You are not authorized' });
    }
  }
}

module.exports = router" >> router/router.js

echo "DONE========================================================"

printf "const db = require('../data/db-config')

function find(table) {
  return db(table) 
}
    
function findById(id,table) {
  return db(table).where({ id }).first() 
}

function findBy(filter) {
  return db('users').where(filter).orderBy('id'); 
}

function add(addedObject, table) { 
  return( 
    db(table) 
    .insert(addedObject) 
    .then( id => {
      return findById(id[0], table)
    })
  )
}

function update(changes, id, table) {
  return db(table) 
  .update(changes)
  .where({ id })
  .then( () => {
      return findById(id, table)
  })
}

function remove(id, table) {
  let removed
  findById(id, table).then(rez => removed=rez)
  if (removed.id) {
    return db(table) 
    .where({ id })
    .del()
    .then(() => {
      return removed
    })
  } else {
    return res.status(404).json({ msg: 'no object with that ID exists'})
  }
}

module.exports ={
  find,
  findById,
  findBy,
  add,
  update,
  remove
}" >> router/helper.js

echo "DONE========================================================"

printf "
module.exports = {

  development: {
    client: 'sqlite3',
    useNullAsDefault: true,
    connection: {          
      filename: './data/database.db3', // where to change the name of the database 
    },
    migrations: {
      directory: './data/migrations'
    },
    seeds: {
      directory: './data/seeds'
    },
  },
  testing:{
    client: 'sqlite3',
    useNullAsDefault: true,
    connection: {          
      filename: './data/database-testing.db3', // where to change the name of the database 
    },
    migrations: {
      directory: './data/migrations'
    },
    seeds: {
      directory: './data/seeds'
    },
  },
  production: {
    client: 'sqlite3',
    useNullAsDefault: true,
    connection: {          
      filename: './data/database.db3', // where to change the name of the database 
    },
    migrations: {
      directory: './data/migrations'
    },
    seeds: {
      directory: './data/seeds'
    },
  }
}" > knexfile.js
sed -i "7 s+.*+    \"server\": \"nodemon index.js\",\n    \"start\": \"node index.js\", \n    \"test\": \"cross-env DB_ENV=testing jest --watch\" \n  },\n   \"jest\": { \n    \"testEnvironment\": \"node\" +" package.json
knex migrate:make init

printf "
exports.up = function(knex) {
  return knex.schema.createTable('TABLE', tbl => {
    tbl.increments()
    tbl.string('username').notNullable().unique().index()
    tbl.string('password').notNullable()
  })
}
exports.down = function(knex) {
  return knex.schema.dropTableIfExists('TABLE')
}
" >> data/migrations/TABLE_example.txt

printf '
const bcryptjs = require("bcryptjs")
const jwt = require("jsonwebtoken")

const router = require("express").Router()

const helper = require("../router/helper")

router.post("/register", (req, res) => {
  const credentials = req.body

  if (isValid(credentials)) {
    const rounds = process.env.BCRYPT_ROUNDS || 8

    const hash = bcryptjs.hashSync(credentials.password, rounds)

    credentials.password = hash

    helper.add(credentials)
    .then(user => {
      const token = makeJwt(user)

      res.status(201).json({ data: user, token })
    })
    .catch(error => {
      res.status(500).json({ message: error.message })
    })
  } else {
    res.status(400).json({
      message: "please provide username and password and the password shoud be alphanumeric",
    })
  }
})

router.post("/login", (req, res) => {
  const { username, password } = req.body

  if (isValid(req.body)) {
    helper.findBy({ username: username })
    .then(([user]) => {
      if (user && bcryptjs.compareSync(password, user.password)) {
        const token = makeJwt(user)

        res.status(200).json({ token })
      } else {
        res.status(401).json({ message: "Invalid credentials" })
      }
    })
    .catch(error => {
      res.status(500).json({ message: error.message })
    })
  } else {
    res.status(400).json({
      message: "please provide username and password and the password shoud be alphanumeric",
    })
  }
})

function makeJwt({ id, username, role }) {
  const payload = {
    username,
    role,
    subject: id,
  }
  const config = {
    jwtSecret: process.env.JWT_SECRET || "is it secret, is it safe?",
  }
  const options = {
    expiresIn: "8 hours",
  }

  return jwt.sign(payload, config.jwtSecret, options)
}

function isValid(user) {
  return Boolean(user.username && user.password && typeof user.password === "string")
}

module.exports = router' >> auth/auth-router.js
printf '
const jwt = require("jsonwebtoken")

module.exports = (req, res, next) => {
  const token = req.headers.authorization
  const secret = process.env.JWT_SECRET || "is it secret, is it safe?"

  if (token) {
    jwt.verify(token, secret, (err, decodedToken) => {
      if (err) {
        res.status(401).json({ message: "Not Allowed" })
      } else {
        req.jwt = decodedToken

        next()
      }
    })
  } else {
    res.status(401).json({ message: "No token!" })
  }
}
' >> auth/restricted-middleware.js
printf '  
need to work on helper functions to return messages when object with specific ID is not in the database. for now it returns empty objects

'>> Z_REQUIRED_EDITS.md
clear
npm run server


