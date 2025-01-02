import 'reflect-metadata';
import express from 'express';
import cors from 'cors';
import helmet from 'helmet';

// Importar rutas (cuando las creemos)
// import routes from './routes';

const app = express();

// Middlewares
app.use(cors());
app.use(helmet());
app.use(express.json());

// Rutas base
app.get('/health', (req, res) => {
    res.status(200).send('Server is running');
});

// Cuando tengamos las rutas:
// app.use('/api', routes);

export default app;