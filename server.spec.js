const supertest = require("supertest")
const server = require("./server")
const db = require("./data/db-config")

let token
describe("auth testing", () => {
  
  describe("environment", () => {
    it('should set the DB_ENV variable to "testing"', () => {
        expect(process.env.DB_ENV).toBe("testing");
    });
  });
  
  describe("/register", () => {
    it("should return 201 when user is succefully created", async () => {
      await db("users").truncate()
      return supertest(server)
        .post("/api/auth/register")
        .send({ username: "sam", password: "pass" })
        .then(res => {
          expect(res.status).toBe(201)
        })
    })
    it('should return 500 if user is already created', async () => {
      return supertest(server)
      .post("/api/auth/register")
      .send({ username: "sam", password: "pass" })
      .then(res => {
        expect(res.status).toBe(500)
      })
    })
  })
  
  describe('/login', () => {
    it('should return 400 upon unsuccessful login', async () => {
      return supertest(server)
      .post("/api/auth/login")
      .send({ username: "sam", password: "" })
      .then(res => {
        expect(res.status).toBe(400)
      })
    })
    it('should return 200 upon successful login', async () => {
      return supertest(server)
      .post("/api/auth/login")
      .send({ username: "sam", password: "pass" })
      .then(res => {
        token = res.body.token
        expect(res.status).toBe(200)
      })
    })
  })

  describe('/items', () => {
    it('add an item to the database', async () => {
      await db("items").truncate()
      return supertest(server)
      .post("/api/items")
      .send({ item: "Lens", user_id: 2 })
      .then(res => {
        expect(res.status).toBe(200)
      })  
    })
    it('reject adding same item to the database',  () => {
      return supertest(server)
      .post("/api/items")
      .send({ item: "Lens", user_id: 2 })
      .then(res => {
        expect(res.status).toBe(500)
      })  
    })
    it('get a list of items from the database',  () => {
      return supertest(server)
      .get("/api/items")
      .then(res => {
        expect(res.status).toBe(200)
      })  
    })
    it('get the item by the ID',  () => {
      return supertest(server)
      .get("/api/items/1")
      .then(res => {
        expect(res.status).toBe(200)
      })  
    })
    it('update the item',  () => {
      return supertest(server)
      .put("/api/items/1")
      .send({ item: "cam"}) 
      .then(res => {
        expect(res.status).toBe(200)
      })  
    })
    it('delete the item',  () => {
      return supertest(server)
      .del("/api/items/1")
      .then(res => {
        expect(res.status).toBe(200)
      })  
    })
  })

})