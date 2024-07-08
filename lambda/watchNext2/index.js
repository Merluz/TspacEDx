import mongoose from 'mongoose';
import connect_to_db from './db.mjs';

export const handler = async (event) => {
    // Estrarre current_id dal corpo della richiesta
    const { current_id } = JSON.parse(event.body);

    // Abilita CORS (Cross-Origin Resource Sharing)
    const headers = {
        'Access-Control-Allow-Origin': '*', // Consentire l'accesso da tutte le origini
        'Access-Control-Allow-Headers': 'Content-Type',
    };

    // Verifica se la richiesta è di tipo OPTIONS per le preflight CORS
    if (event.httpMethod === 'OPTIONS') {
        return {
            statusCode: 200,
            headers,
            body: 'OK',
        };
    }

    try {
        // Connessione al database
        await connect_to_db();

        const WatchNextData = mongoose.connection.db.collection('watch_next_data');
        const TspacedxData = mongoose.connection.db.collection('tspacedx_data');
        
        // Trova il documento con il next_id corrispondente al current_id fornito
        const watchNextData = await WatchNextData.findOne({ current_id: current_id });
        
        if (!watchNextData) {
            return {
                statusCode: 404,
                headers,
                body: JSON.stringify({ message: 'next_id non trovato' }),
            };
        }

        const next_id = watchNextData.next_id;

        // Trova il documento nella collezione tspacedx_data con l'_id corrispondente al next_id
        const tspacedxData = await TspacedxData.findOne({ _id: next_id });

        if (!tspacedxData) {
            return {
                statusCode: 404,
                headers,
                body: JSON.stringify({ message: 'Documento non trovato' }),
            };
        }

        return {
            statusCode: 200,
            headers,
            body: JSON.stringify(tspacedxData),
        };
    } catch (error) {
        return {
            statusCode: 500,
            headers,
            body: JSON.stringify({ message: 'Errore del server', error: error.message }),
        };
    }
};
