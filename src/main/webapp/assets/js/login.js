document.addEventListener("DOMContentLoaded", function () {

    const form = document.querySelector("form");
    if (!form) return;

    form.addEventListener("submit", function (event) {

        const emailInput = document.querySelector('input[name="email"]');
        const passwordInput = document.querySelector('input[name="password"]');

        const email = emailInput ? emailInput.value.trim() : "";
        const password = passwordInput ? passwordInput.value : "";

        if (!email.includes("@")) {
            alert("Enter a valid email address");
            event.preventDefault();
            return;
        }

        if (password.length < 6) {
            alert("Password must contain minimum 6 characters");
            event.preventDefault();
        }
    });
});
