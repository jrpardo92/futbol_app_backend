// services/authService.ts
import { PrismaClient } from '@prisma/client';
import jwt from 'jsonwebtoken';

const prisma = new PrismaClient();

export class AuthService {
  async findOrCreateUser(googleProfile: any) {
    try {
      const { id: googleId, emails, displayName, photos } = googleProfile;
      const photoUrl = photos?.[0]?.value || null;
      
      let user = await prisma.usuarios.findFirst({
        where: { 
          google_id: googleId 
        }
      });

      if (!user) {
        user = await prisma.usuarios.create({
          data: {
            google_id: googleId,
            email: emails[0].value,
            nombre: displayName,
            foto_perfil: photoUrl,
            estado: 'ACTIVO'
          }
        });
      }

      return user;
    } catch (error) {
      console.error('Error en findOrCreateUser:', error);
      throw new Error(`Error al procesar usuario: ${error instanceof Error ? error.message : 'Unknown error'}`);
    }
  }

  // Método para generar el token JWT
  generateToken(userId: string): string {
    try {
      return jwt.sign(
        { userId },
        process.env.JWT_SECRET!,
        { expiresIn: process.env.JWT_EXPIRATION || '24h' }
      );
    } catch (error) {
      console.error('Error generando token:', error);
      throw new Error('Error al generar el token');
    }
  }
}