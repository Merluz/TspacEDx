import mongoose from 'mongoose';
import dotenv from 'dotenv';

dotenv.config({ path: './variables.env' });

mongoose.Promise = global.Promise;
let isConnected;

const connect_to_db = () => {
    if (isConnected) {
        console.log('=> using existing database connection');
        return Promise.resolve();
    }
 
    console.log('=> using new database connection');
    return mongoose.connect(process.env.DB, { useNewUrlParser: true, useUnifiedTopology: true, dbName: 'tspacedx' }).then(db => {
        isConnected = db.connections[0].readyState;
    });
};

export default connect_to_db;
