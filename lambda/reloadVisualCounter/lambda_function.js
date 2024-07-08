const mongoose = require('mongoose');
const connectToDB = require('./db'); // Importa la funzione di connessione a MongoDB

mongoose.connect(process.env.DB, { useNewUrlParser: true, useUnifiedTopology: true, dbName: 'tspacedx' })
  .then(() => console.log('Connected to MongoDB'))
  .catch(err => console.error('Error connecting to MongoDB:', err));

const achievementSchema = new mongoose.Schema({
  _id: String,
  next_video_count: {
    type: Number,
    default: 0
  },
  achievement: {
    type: String,
    default: 'Watched and moved to another video'
  },
  date: {
    type: Date,
    default: Date.now
  },
  vip: {
    type: Boolean,
    default: false  // Impostato a false di default, verrà cambiato a true se necessario
  }
});

const AchievementModel = mongoose.model('Achievement', achievementSchema, 'tspacedx_achievement');

exports.lambda_handler = async (event, context) => {
  try {
    console.log('Received event:', JSON.stringify(event));

    // Connessione a MongoDB prima di eseguire la logica della Lambda
    await connectToDB();

    const _id = event['_id'];
    if (!_id) {
      throw new Error('Missing _id in event');
    }

    // Aggiorna next_video_count nel documento MongoDB
    await updateNextVideoCount(_id);

    // Recupera il documento aggiornato dal database
    const updatedDoc = await AchievementModel.findOne({ _id });

    if (!updatedDoc) {
      throw new Error(`Failed to find document for _id: ${_id}`);
    }

    return {
      statusCode: 200,
      body: JSON.stringify({ next_video_count: updatedDoc.next_video_count })
    };
  } catch (error) {
    console.error('Error processing request:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({ message: `Error processing request: ${error.message}` })
    };
  }
};

async function updateNextVideoCount(_id) {
  try {
    let achievementDoc = await AchievementModel.findOne({ _id });

    if (!achievementDoc) {
      achievementDoc = new AchievementModel({ _id });
    }

    achievementDoc.next_video_count += 1;

    // Check if next_video_count is greater than 99
    if (achievementDoc.next_video_count > 99 && !achievementDoc.vip) {
      achievementDoc.vip = true;
    }

    await achievementDoc.save();
  } catch (error) {
    console.error('Error updating next_video_count:', error);
    throw error;
  }
}
