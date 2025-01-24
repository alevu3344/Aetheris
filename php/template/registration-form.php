<section>
        <div>
            <a href = "index.php">
                <img src="upload/icons/cross.png" alt="Logo">
            </a>
        </div>
        
        <h2>Register</h2>
        <form>
            <fieldset>
                <label for="name">Name</label>
                <input type="text" name="name" id="name" placeholder="Your Name" required>

                <label for="surname">Surname</label>
                <input type="text" name="surname" id="surname" placeholder="Your Surname" required>

                <label for="birthday">Birthday</label>
                <input type="date" name="birthday" id="birthday" placeholder="2000-01-01" required>
        

                <label for="city">City</label>
                <input type="text" name="city" id="city" placeholder="Milano" required>

                <label for="address">Address</label>
                <input type="text" name="address" id="address" placeholder="Corso Cavour 3" required>

                <label for="phonenumber">Phone Number</label>
                <input type="phonenumber" name="phonenumber" id="phonenumber" placeholder="3480406954" required>

                <label for="email">Email</label>
                <input type="email" name="email" id="email" placeholder="Your Email" required>

                <label for="username">Username</label>
                <input type="text" name="username" id="username" placeholder="Choose a Username" required>

                <label for="password">Password</label>
                <input type="password" name="password" id="password" placeholder="Choose a Password" required>

                <label for="repeat-password">Repeat Password</label>
                <input type="password" name="repeat-password" id="repeat-password" placeholder="Repeat your Password" required>

                <p class>
                    <a id="back-to-login" href="#">Already have an account? Login</a>
                </p>
                <?php if(isset($_SESSION["Username"])): ?>
                    <a href="index.php">Back to page</a>
                <?php else :?>
                    <button type="submit">Register</button>
                <?php endif; ?>
            </fieldset>
        </form>

        <p>By registering, you agree to our terms and conditions.</p>
</section>
