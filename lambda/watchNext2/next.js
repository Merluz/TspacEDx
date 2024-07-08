const mongoose = require('mongoose');

const next_schema = new mongoose.Schema({
    title: String,
    url: String,
    description: String,
    speakers: String
}, { collection: 'tspacedx_data' });

module.exports = mongoose.model('next', next_schema);


