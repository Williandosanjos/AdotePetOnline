-- Script de inicialização do banco DEV
USE adotepet_dev;

-- Limpar tabelas existentes (cuidado em produção!)
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS adoptions;
DROP TABLE IF EXISTS dogs;
DROP TABLE IF EXISTS cats;
DROP TABLE IF EXISTS pets;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS images;
SET FOREIGN_KEY_CHECKS = 1;

-- Tabela de usuários
CREATE TABLE users (
                       id BIGINT PRIMARY KEY AUTO_INCREMENT,
                       email VARCHAR(100) UNIQUE NOT NULL,
                       password VARCHAR(255) NOT NULL,
                       full_name VARCHAR(150) NOT NULL,
                       phone VARCHAR(20),
                       address TEXT,
                       user_type ENUM('DONOR', 'ADOPTER', 'ADMIN') DEFAULT 'ADOPTER',
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                       active BOOLEAN DEFAULT TRUE,
                       INDEX idx_email (email),
                       INDEX idx_user_type (user_type)
);

-- Tabela base de pets
CREATE TABLE pets (
                      id BIGINT PRIMARY KEY AUTO_INCREMENT,
                      name VARCHAR(100) NOT NULL,
                      age INT,
                      species VARCHAR(50) NOT NULL,
                      breed VARCHAR(100),
                      color VARCHAR(50),
                      size ENUM('SMALL', 'MEDIUM', 'LARGE'),
                      health_status TEXT,
                      vaccinated BOOLEAN DEFAULT FALSE,
                      castrated BOOLEAN DEFAULT FALSE,
                      description TEXT,
                      status ENUM('AVAILABLE', 'ADOPTED', 'PENDING') DEFAULT 'AVAILABLE',
                      user_id BIGINT,
                      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                      updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                      FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
                      INDEX idx_species (species),
                      INDEX idx_status (status),
                      INDEX idx_user_id (user_id)
);

-- Tabela específica para cachorros
CREATE TABLE dogs (
                      pet_id BIGINT PRIMARY KEY,
                      dog_breed VARCHAR(100),
                      energy_level ENUM('LOW', 'MEDIUM', 'HIGH'),
                      good_with_kids BOOLEAN DEFAULT TRUE,
                      good_with_other_pets BOOLEAN DEFAULT TRUE,
                      FOREIGN KEY (pet_id) REFERENCES pets(id) ON DELETE CASCADE
);

-- Tabela específica para gatos
CREATE TABLE cats (
                      pet_id BIGINT PRIMARY KEY,
                      cat_breed VARCHAR(100),
                      indoor_outdoor ENUM('INDOOR', 'OUTDOOR', 'BOTH'),
                      litter_trained BOOLEAN DEFAULT TRUE,
                      FOREIGN KEY (pet_id) REFERENCES pets(id) ON DELETE CASCADE
);

-- Tabela de imagens
CREATE TABLE images (
                        id BIGINT PRIMARY KEY AUTO_INCREMENT,
                        pet_id BIGINT NOT NULL,
                        url VARCHAR(500) NOT NULL,
                        is_main BOOLEAN DEFAULT FALSE,
                        uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                        FOREIGN KEY (pet_id) REFERENCES pets(id) ON DELETE CASCADE,
                        INDEX idx_pet_id (pet_id)
);

-- Tabela de adoções
CREATE TABLE adoptions (
                           id BIGINT PRIMARY KEY AUTO_INCREMENT,
                           pet_id BIGINT NOT NULL,
                           adopter_id BIGINT NOT NULL,
                           donor_id BIGINT NOT NULL,
                           status ENUM('PENDING', 'APPROVED', 'REJECTED', 'COMPLETED') DEFAULT 'PENDING',
                           adoption_date DATE,
                           notes TEXT,
                           created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                           updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                           FOREIGN KEY (pet_id) REFERENCES pets(id),
                           FOREIGN KEY (adopter_id) REFERENCES users(id),
                           FOREIGN KEY (donor_id) REFERENCES users(id),
                           UNIQUE KEY uk_pet_adoption (pet_id, adopter_id),
                           INDEX idx_status (status),
                           INDEX idx_adopter (adopter_id),
                           INDEX idx_donor (donor_id)
);

-- Dados iniciais para teste
INSERT INTO users (email, password, full_name, phone, user_type) VALUES
                                                                     ('admin@adotepet.com', '$2a$10$YourHashedPasswordHere', 'Administrador', '(11) 99999-9999', 'ADMIN'),
                                                                     ('doador@email.com', '$2a$10$YourHashedPasswordHere', 'João Doador', '(11) 98888-8888', 'DONOR'),
                                                                     ('adotante@email.com', '$2a$10$YourHashedPasswordHere', 'Maria Adotante', '(11) 97777-7777', 'ADOPTER');

INSERT INTO pets (name, age, species, breed, color, size, description, user_id) VALUES
                                                                                    ('Rex', 3, 'DOG', 'Vira-lata', 'Caramelo', 'MEDIUM', 'Cachorro muito brincalhão e carinhoso', 2),
                                                                                    ('Mimi', 2, 'CAT', 'Siamês', 'Branco e Preto', 'SMALL', 'Gata tranquila e amorosa', 2);

INSERT INTO dogs (pet_id, dog_breed, energy_level, good_with_kids) VALUES
    (1, 'Vira-lata', 'HIGH', TRUE);

INSERT INTO cats (pet_id, cat_breed, indoor_outdoor, litter_trained) VALUES
    (2, 'Siamês', 'INDOOR', TRUE);

INSERT INTO images (pet_id, url, is_main) VALUES
                                              (1, '/uploads/pets/rex1.jpg', TRUE),
                                              (2, '/uploads/pets/mimi1.jpg', TRUE);

echo Banco de dados inicializado com dados de teste!