function foreignKey(tbl, refTable, name, refColumn) {
  return tbl.integer(name)
  .unsigned()
  .notNullable()
  .references(refColumn || "id")
  .inTable(refTable)
  .onDelete('RESTRICT')
  .onUpdate('CASCADE')
}

exports.up = function(knex) {
  return knex.schema
    .createTable('users', tbl => {
      tbl.increments()
      tbl.string('username').notNullable().unique().index()
      tbl.string('password').notNullable()
      tbl.boolean("renter").defaultTo(false)
    })
    .createTable('items', tbl => {
      tbl.increments()
      tbl.string('item').notNullable().unique().index()
      foreignKey(tbl, "users", "user_id")
      tbl.boolean('rented').defaultTo(false)
    })
    .createTable('orders', tbl => {
      tbl.increments()
      foreignKey(tbl, "users", "user_id")
      foreignKey(tbl, "items", "item_id")
    })
}

exports.down = function(knex) {
  return knex.schema
    .dropTableIfExists('orders')
    .dropTableIfExists('items')
    .dropTableIfExists('users')
}