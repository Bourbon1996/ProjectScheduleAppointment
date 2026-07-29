document.addEventListener("DOMContentLoaded", function() {
    const cards = document.querySelectorAll(".doctor-card");
    const cardsPerPage = 6;
    const paginationContainer = document.getElementById("pagination-controls");
    
    let totalPages = Math.ceil(cards.length / cardsPerPage);
    let currentPage = 1;

    function displayPage(page) {
        currentPage = page;
        let start = (currentPage - 1) * cardsPerPage;
        let end = start + cardsPerPage;

        cards.forEach((card, index) => {
            if (index >= start && index < end) {
                card.style.display = "flex";
            } else {
                card.style.display = "none";
            }
        });

        renderPagination();
    }

    function renderPagination() {
        paginationContainer.innerHTML = ""; 

        if (totalPages <= 1) return;

        // 1. Nút Về trang đầu tiên («)
        let firstLi = document.createElement("li");
        firstLi.className = `page-item ${currentPage === 1 ? 'disabled' : ''}`;
        firstLi.innerHTML = `<a class="page-link" href="javascript:void(0)">&laquo;</a>`;
        firstLi.onclick = () => { if (currentPage > 1) displayPage(1); };
        paginationContainer.appendChild(firstLi);

        // 2. Nút Lùi lại 1 trang (‹)
        let prevLi = document.createElement("li");
        prevLi.className = `page-item ${currentPage === 1 ? 'disabled' : ''}`;
        prevLi.innerHTML = `<a class="page-link" href="javascript:void(0)">&lsaquo;</a>`;
        prevLi.onclick = () => { if (currentPage > 1) displayPage(currentPage - 1); };
        paginationContainer.appendChild(prevLi);

        // --- Logic tính toán số trang hiển thị (Giới hạn tối đa 3 trang ở giữa) ---
        let maxVisible = 3; 
        let startPage = Math.max(1, currentPage - 1);
        let endPage = Math.min(totalPages, startPage + maxVisible - 1);

        // Điều chỉnh lại nếu đang ở những trang cuối
        if (endPage - startPage + 1 < maxVisible) {
            startPage = Math.max(1, endPage - maxVisible + 1);
        }

        // 3. Render các nút số trang
        for (let i = startPage; i <= endPage; i++) {
            let li = document.createElement("li");
            li.className = `page-item ${currentPage === i ? 'active' : ''}`;
            li.innerHTML = `<a class="page-link" href="javascript:void(0)">${i}</a>`;
            li.onclick = () => displayPage(i);
            paginationContainer.appendChild(li);
        }

        // 4. Render ô 3 chấm (...) và Nút trang cuối cùng (nếu còn trang phía sau)
        if (endPage < totalPages) {
            let dotsLi = document.createElement("li");
            dotsLi.className = "page-item page-ellipsis disabled";
            dotsLi.innerHTML = `<span class="page-link">...</span>`; // Bạn có thể thay bằng thẻ <input> nếu muốn làm chức năng nhập trang
            paginationContainer.appendChild(dotsLi);
            
            let lastPageLi = document.createElement("li");
            lastPageLi.className = `page-item`;
            lastPageLi.innerHTML = `<a class="page-link" href="javascript:void(0)">${totalPages}</a>`;
            lastPageLi.onclick = () => displayPage(totalPages);
            paginationContainer.appendChild(lastPageLi);
        }

        // 5. Nút Tiến tới 1 trang (›)
        let nextLi = document.createElement("li");
        nextLi.className = `page-item ${currentPage === totalPages ? 'disabled' : ''}`;
        nextLi.innerHTML = `<a class="page-link" href="javascript:void(0)">&rsaquo;</a>`;
        nextLi.onclick = () => { if (currentPage < totalPages) displayPage(currentPage + 1); };
        paginationContainer.appendChild(nextLi);

        // 6. Nút Tới trang cuối cùng (»)
        let lastLi = document.createElement("li");
        lastLi.className = `page-item ${currentPage === totalPages ? 'disabled' : ''}`;
        lastLi.innerHTML = `<a class="page-link" href="javascript:void(0)">&raquo;</a>`;
        lastLi.onclick = () => { if (currentPage < totalPages) displayPage(totalPages); };
        paginationContainer.appendChild(lastLi);
    }

    if (cards.length > 0) {
        displayPage(1);
    }
});