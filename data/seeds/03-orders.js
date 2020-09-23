
exports.seed = function(knex) {
  // Deletes ALL existing entries
  return knex('orders').truncate()
    .then(function () {
      // Inserts seed entries
      return knex('orders').insert([
        {id: 1, user_id: 1, item_id: 3},
      ]);
    });
};
