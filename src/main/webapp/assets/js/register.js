document.addEventListener("DOMContentLoaded", function () {

    const form = document.querySelector("form");
    if (!form) return; // safety check

    form.addEventListener("submit", function (event) {

        // Safely read each field (null-safe)
        const nameInput = document.querySelector('input[name="name"]');
        const emailInput = document.querySelector('input[name="email"]');
        const phoneInput = document.querySelector('input[name="phone"]');
        const passwordInput = document.querySelector('input[name="password"]');
        const confirmPasswordInput = document.querySelector('input[name="confirmPassword"]');

        const name = nameInput ? nameInput.value.trim() : null;
        const email = emailInput ? emailInput.value.trim() : null;
        const phone = phoneInput ? phoneInput.value.trim() : null;
        const password = passwordInput ? passwordInput.value : null;
        const confirmPassword = confirmPasswordInput ? confirmPasswordInput.value : null;

        // Name validation (only if name field exists)
        if (name !== null && name.length < 3) {
            alert("Name must contain minimum 3 characters");
            event.preventDefault();
            return;
        }

        // Email validation (only if email field exists)
        if (email !== null && !email.includes("@")) {
            alert("Enter a valid email address");
            event.preventDefault();
            return;
        }

        // Phone validation (only if phone field exists and has a value)
        if (phone !== null && phone.length > 0 && phone.length < 10) {
            alert("Enter a valid phone number (minimum 10 digits)");
            event.preventDefault();
            return;
        }

        // Password validation (only if password field exists)
        if (password !== null && password.length < 6) {
            alert("Password must contain minimum 6 characters");
            event.preventDefault();
            return;
        }

        // Confirm password (only if both fields exist)
        if (password !== null && confirmPassword !== null && password !== confirmPassword) {
            alert("Passwords do not match");
            event.preventDefault();
            return;
        }
    });
});