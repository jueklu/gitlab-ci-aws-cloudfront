// Function to handle button clicks
function handleButtonClick() {
    const paragraph = document.querySelector("p");
    // Toggle text between text
    if (paragraph.textContent === "Hi there, click me.") {
        paragraph.textContent = "Button was clicked.";
    } else {
        paragraph.textContent = "Hi there, click me.";
    }
}

// Attach event listener when the DOM is ready
document.addEventListener("DOMContentLoaded", () => {
    const button = document.querySelector("#myButton");
    button.addEventListener("click", handleButtonClick);
});
