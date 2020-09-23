
exports.seed = function(knex) {
  // Deletes ALL existing entries
  return knex('items').truncate()
    .then(function () {
      // Inserts seed entries
      return knex('items').insert([
        {id: 1, item: 'Camera', user_id: 1, rented: false},
        {id: 2, item: 'Shoulder Bag', user_id: 1, rented: false},
        {id: 3, item: 'Large Battery', user_id: 1, rented: true}
      ]);
    });
};
