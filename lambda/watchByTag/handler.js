// Importa le librerie necessarie
const connect_to_db = require('./db');
const talk = require('./Talk');

// Funzione principale per gestire la richiesta
exports.watchByTag = async (event, context, callback) => {
    // Imposta il comportamento asincrono
    context.callbackWaitsForEmptyEventLoop = false;
    
    // Gestione della richiesta OPTIONS per CORS
    if (event.httpMethod === 'OPTIONS') {
        return {
            statusCode: 200,
            headers: {
                'Access-Control-Allow-Origin': '*', // Permette l'accesso da qualsiasi origine
                'Access-Control-Allow-Methods': 'OPTIONS,POST,GET', // Metodi consentiti
                'Access-Control-Allow-Headers': 'Content-Type', // Header consentiti
            },
            body: JSON.stringify('CORS preflight success'),
        };
    }
    
    // Gestione della richiesta effettiva
    try {
        console.log('Received event:', JSON.stringify(event, null, 2));
        
        let body = {};
        if (event.body) {
            body = JSON.parse(event.body);
        }
        
        // Controllo sul tag
        if (!body.tag) {
            return {
                statusCode: 400,
                headers: { 'Content-Type': 'text/plain' },
                body: 'Tag parameter is missing.'
            };
        }
        
        // Impostazioni predefinite per il numero di documenti per pagina e pagina
        body.doc_per_page = body.doc_per_page || 10;
        body.page = body.page || 1;
        
        // Connessione al database
        await connect_to_db();
        
        // Query per trovare i talk con il tag specificato
        const talks = await talk.find({ tags: body.tag })
            .skip((body.doc_per_page * body.page) - body.doc_per_page)
            .limit(body.doc_per_page);
        
        // Ritorna i risultati
        return {
            statusCode: 200,
            headers: {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*', // Permette l'accesso da qualsiasi origine
                'Access-Control-Allow-Methods': 'OPTIONS,POST,GET', // Metodi consentiti
                'Access-Control-Allow-Headers': 'Content-Type', // Header consentiti
            },
            body: JSON.stringify(talks),
        };
    } catch (err) {
        console.error('Error:', err);
        return {
            statusCode: err.statusCode || 500,
            headers: { 'Content-Type': 'text/plain' },
            body: 'Could not fetch the talks.',
        };
    }
};
