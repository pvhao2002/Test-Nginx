package org.app.service2;

import org.app.service2.repo.ProductRepo;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

import java.util.Random;

@SpringBootApplication
public class Service2Application {

    private final ProductRepo productRepo;

    public Service2Application(ProductRepo productRepo) {
        this.productRepo = productRepo;
    }

    public static void main(String[] args) {
        SpringApplication.run(Service2Application.class, args);
    }

    @Bean
    InitializingBean sendDatabase() {
        return () -> {
            var faker = new com.github.javafaker.Faker(new Random(24));
            // check if the database is not have product then insert 1000 products with unique name with faker java library
            if (productRepo.count() == 0) {
                for (int i = 0; i < 1000; i++) {
                    var product = new org.app.service2.entity.Product();
                    product.setName(faker.commerce().productName());
                    product.setPrice(new java.math.BigDecimal(faker.commerce().price()));
                    productRepo.save(product);
                }
            }
        };
    }
}
