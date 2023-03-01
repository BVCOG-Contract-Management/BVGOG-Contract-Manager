// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import { fileIcon } from "./helpers/file-helper"

// On turbo:load

document.addEventListener("turbo:load", () => {
    // New vendor option selected in contracts
    // Get references to the vendor select field and the new vendor input field
    const vendorSelect = document.querySelector('#vendor_id');
    const newVendorField = document.querySelector('#new_vendor_field');

    // Add an event listener to the vendor select field
    if (vendorSelect) {
        vendorSelect.addEventListener('change', (event) => {
            // If the value of the vendor select field is 'new_vendor'
            if (event.target.value === 'new') {
                // Show the new vendor input field
                newVendorField.classList.remove('is-hidden');
            } else {
                // Hide the new vendor input field
                newVendorField.classList.add('is-hidden');
            }
        });
    }

    // Set cursor blink in contracts search table
    const searchInput = document.querySelector('#contracts-search-input');
    if (searchInput) {
        // Check if the search input field is empty
        if (searchInput.value !== '') {
            // Set the cursor blink
            searchInput.focus();
            searchInput.setSelectionRange(searchInput.value.length, searchInput.value.length);
        }
    }

    // Contract uploaded documents
    const uploadedContractDocumentsInput = document.querySelector('#contract-documents-file-input');
    if (uploadedContractDocumentsInput) {
        const uploadedContractDocumentsTable = document.querySelector('#uploaded-contract-documents-table');
        // Get tbody element of the table
        const uploadedContractDocumentsTableBody = uploadedContractDocumentsTable.querySelector('tbody');
        // for each file that is uploaded, add a new row to the table
        uploadedContractDocumentsInput.addEventListener('change', (event) => {
            for (let i = 0; i < event.target.files.length; i++) {
                const file = event.target.files[i];
                const fileRow = document.createElement('tr');
                // Shorten the file name if it is too long
                fileRow.innerHTML = `
                    <td>
                        ${fileIcon(file.type)} 
                        <strong>${file.name.length > 30 ? file.name.substring(0, 30) + '...' : file.name}</strong>
                    </td>
                    <td>
                        <button type="button" class="button is-danger is-small" data-file-name="${file.name} class="${file.name}">
                            <span class="icon is-small">
                                <i class="fas fa-times"></i>
                            </span>
                            <span>Remove</span>
                        </button>
                    </td>
                `;
                uploadedContractDocumentsTableBody.appendChild(fileRow);
                // Add an event listener to the button
                const button = fileRow.querySelector(`button[type=button]`);
                button.addEventListener('click', (event) => {
                    // Remove the file from the input
                    const filtered = Array.from(uploadedContractDocumentsInput.files).filter((f) => f.name !== file.name);
                    const fileList = new DataTransfer();
                    filtered.forEach((f) => fileList.items.add(f));
                    uploadedContractDocumentsInput.files = fileList.files;
                    // Remove the row from the table
                    fileRow.remove();
                });
            }
        }
        );
    }
});


