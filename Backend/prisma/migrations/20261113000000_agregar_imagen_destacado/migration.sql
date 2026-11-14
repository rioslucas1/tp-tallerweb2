-- DropForeignKey
ALTER TABLE "Producto" DROP CONSTRAINT "Producto_id_categoria_fkey";

-- DropIndex
DROP INDEX "Producto_id_categoria_key";

-- DropIndex
DROP INDEX "Producto_id_subcategoria_key";

-- DropIndex
DROP INDEX "Subcategoria_id_categoria_key";

-- AlterTable
ALTER TABLE "Producto" ADD COLUMN     "destacado" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "imagen" TEXT;

-- AddForeignKey
ALTER TABLE "Producto" ADD CONSTRAINT "Producto_id_subcategoria_fkey" FOREIGN KEY ("id_subcategoria") REFERENCES "Subcategoria"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

