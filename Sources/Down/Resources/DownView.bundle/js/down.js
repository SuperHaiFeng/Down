//hljs.highlightAll();

document.addEventListener('DOMContentLoaded', () => {
    hljs.highlightAll();
    
    addCodeBlockTopBar();
});

function addPreCodeObserver() {
    const observer = new MutationObserver(() => {
        if (document.querySelectorAll("pre code").length > 0) {
            observer.disconnect();
            addCodeBlockTopBar();
        }
    });
    observer.observe(document.body, { childList: true, subtree: true });
}

function addCodeBlockTopBar() {
    document.querySelectorAll("pre").forEach((pre) => {
        const code = pre.querySelector("code");
        let langClass = code.className.match(/language-(\w+)/);
        let language = langClass ? langClass[1] : "";

        const langLabel = document.createElement("div");
        langLabel.innerText = language;
        langLabel.classList.add("code-lang-label");
        
        const button = document.createElement("button");
        button.innerText = "Copy";
        button.classList.add("copy-button");

        button.addEventListener("click", () => {
            const code = pre.querySelector("code").innerText;
            navigator.clipboard.writeText(code).then(() => {
                button.innerText = "Copied!";
                setTimeout(() => button.innerText = "Copy", 1500);
            }).catch((err) => {
                console.error("Copy failed:", err);
            });
        });

        const wrapper = document.createElement("div");
        wrapper.classList.add("code-wrapper");
        
        pre.parentNode.insertBefore(wrapper, pre);
        wrapper.appendChild(pre);
        wrapper.appendChild(langLabel);
        wrapper.appendChild(button);
    });
}
