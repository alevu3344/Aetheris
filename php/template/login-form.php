<section>
    <div>
    <a href = "index.php">
            <img src="upload/icons/cross.png" alt="Logo"/>
    </a>
</div>
    <h2>Login</h2>
    <form>
        <fieldset>
            <label for="username">Username</label>
            <input type="text" name="username" id="username" placeholder="" required>

            <label for="password">Password</label>
            <input type="password" name="password" id="password" placeholder="" required>

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

