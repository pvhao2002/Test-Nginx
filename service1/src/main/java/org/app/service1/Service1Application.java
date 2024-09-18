package org.app.service1;

import org.app.service1.repo.UserRepo;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class Service1Application {
    private final UserRepo userRepo;

    public Service1Application(UserRepo userRepo) {
        this.userRepo = userRepo;
    }

    public static void main(String[] args) {
        SpringApplication.run(Service1Application.class, args);
    }

    @Bean
    InitializingBean sendDatabase() {
        return () -> {
            var faker = new com.github.javafaker.Faker(new java.util.Random(24));
            // check if the database is not have user then insert 1000 users with unique name with faker java library
            if (userRepo.count() == 0) {
                for (int i = 0; i < 1000; i++) {
                    var user = new org.app.service1.entity.User();
                    user.setUsername(faker.name().username());
                    user.setPassword(faker.internet().password());
                    user.setFullName(faker.name().fullName());
                    userRepo.save(user);
                }
            }
        };
    }
}
