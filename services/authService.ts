import { PrismaClient } from '@prisma/client';
import jwt from 'jsonwebtoken';

const prisma = new PrismaClient();

export class AuthService {
  async findOrCreateUser(googleProfile: any) {
    try {
      const { id: googleId, emails, displayName, photos } = googleProfile;
      
      console.log('Google Profile:', {
        googleId,
        email: emails?.[0]?.value,
        displayName,
        photoUrl: photos?.[0]?.value
      });

      // Primero buscar si el usuario existe
      let user = await prisma.usuarios.findFirst({
        where: { 
          google_id: googleId 
        }
      });

      console.log('Usuario existente:', user);

      // Si no existe, crear nuevo usuario
      if (!user) {
        console.log('Creando nuevo usuario...');
        
        user = await prisma.usuarios.create({
          data: {
            google_id: googleId,
            email: emails[0].value,
            nombre: displayName,
            foto_perfil: photos?.[0]?.value || null,
            estado: 'ACTIVO'
          }
        });

        console.log('Usuario creado:', user);
      }

      return user;
    } catch (error) {
      console.error('Error en findOrCreateUser:', error);
      throw new Error(`Error al procesar usuario: ${error instanceof Error ? error.message : 'Unknown error'}`);
    }
  }

  async findUserById(id: string) {
    try {
      const user = await prisma.usuarios.findUnique({
        where: { id }
      });
      
      if (!user) {
        throw new Error('Usuario no encontrado');
      }
      
      return user;
    } catch (error) {
      console.error('Error en findUserById:', error);
      throw new Error(`Error al buscar usuario por ID: ${error instanceof Error ? error.message : 'Unknown error'}`);
    }
  }

  generateToken(userId: string): string {
    return jwt.sign(
      { userId },
      process.env.JWT_SECRET!,
      { expiresIn: process.env.JWT_EXPIRATION || '24h' }
    );
  }
}