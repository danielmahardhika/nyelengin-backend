import { PrismaClient } from '@prisma/client'

export async function seedSpaces(prisma: PrismaClient, userId: string) {
  console.log('Seeding Space & Member...')
  return await prisma.space.create({
    data: {
      name: 'Dompet Utama',
      type: 'PERSONAL',
      // Menggunakan nested write untuk langsung menambahkan user ke space
      members: {
        create: {
          user_id: userId,
          role: 'OWNER'
        }
      }
    }
  })
}