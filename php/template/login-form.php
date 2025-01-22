<section>
    <h2>Login</h2>
    <form>
        <fieldset>
            <label for="username">Username</label>
            <input type="text" name="username" id="username" placeholder="">

            <label for="password">Password</label>
            <input type="password" name="password" id="password" placeholder="">

            <p>
                <a rel="noopener noreferrer" href="#">Forgot Password?</a>
            </p>

            <?php if(isset($_SESSION["Username"])): ?>
                    <a href="index.php">Back to page</a>
                <?php else :?>
                    <button type="submit">Sign In</button>
                <?php endif; ?>
        </fieldset>
    </form>

    <p>Don't have an account?
        <a rel="noopener noreferrer" href="register.php" class="">Sign up</a>
    </p>
</section>

<script src="../js/login.js" defer="true"></script>
