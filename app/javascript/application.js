// Configure your import map in config/importmap.rb. Read more:
// https://github.com/rails/importmap-rails
import '@hotwired/turbo-rails'
import 'controllers'

import { fileIcon } from './helpers/file-helper'

// Helpers
function clearNotice() {
    const notice = document.querySelector('.flash-notice');
    if (notice) {
        // First have the toast slide out by removing the 'slid-out' class
        notice.classList.remove('slid-out');
        // Add event listener to the notice's span
        notice.querySelector('span').addEventListener('click', (event) => {
            notice.classList.add('slid-out');
            // Add event listener earlier than the transitionend event listener
            setTimeout(() => {
                notice.remove();
            }, 5000);
        });
        // Animate the notice to fade out if it is not clicked
        setTimeout(() => {
            notice.classList.add('slid-out');
            setTimeout(() => {
                notice.remove();
            }, 5000);
        }, 5000);
    }
}


// On turbo:load
document.addEventListener('turbo:load', () => {
    // Clear notice
    clearNotice();
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

    // Set cursor blink in search table
    const searchInput = document.querySelector('#search-input');
    if (searchInput) {
        // Check if the search input field is empty
        if (searchInput.value !== '') {
            // Set the cursor blink
            searchInput.focus();
            searchInput.setSelectionRange(
                searchInput.value.length, searchInput.value.length);
        }
    }

    // Contract uploaded documents
    const uploadedContractDocumentsInput =
        document.querySelector('#contract-documents-file-input');
    if (uploadedContractDocumentsInput) {
        const uploadedContractDocumentsTable =
            document.querySelector('#uploaded-contract-documents-table');
        // Get tbody element of the table
        const uploadedContractDocumentsTableBody =
            uploadedContractDocumentsTable.querySelector('tbody');
        // for each file that is uploaded, add a new row to the table
        uploadedContractDocumentsInput.addEventListener('change', (event) => {
            for (let i = 0; i < event.target.files.length; i++) {
                const file = event.target.files[i];
                const fileRow = document.createElement('tr');
                // Shorten the file name if it is too long
                fileRow.innerHTML = `
                    <td>
                        ${fileIcon(file.type)} 
                        <strong>${file.name.length > 30 ? file.name.substring(0, 30) + '...' :
                        file.name}</strong>
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
                    const filtered = Array.from(uploadedContractDocumentsInput.files)
                        .filter((f) => f.name !== file.name);
                    const fileList = new DataTransfer();
                    filtered.forEach((f) => fileList.items.add(f));
                    uploadedContractDocumentsInput.files = fileList.files;
                    // Remove the row from the table
                    fileRow.remove();
                });
            }
        });
    }

    // Vendor review star rating input
    const vendorReviewStars = document.querySelectorAll('.vendor-review-star');
    if (vendorReviewStars) {
        const input = document.querySelector('#vendor_review_rating');
        vendorReviewStars.forEach((star) => {
            console.log(star.parentElement);
            star.addEventListener('click', (event) => {
                // Get the value of the star (the id of the star converted to an
                // integer)
                const value = parseInt(event.target.id);
                // Set the value of the hidden input
                input.value = value;
                // Set the color of the stars
                vendorReviewStars.forEach((s) => {
                    if (parseInt(s.id) <= value) {
                        s.parentElement.classList.add('has-text-warning');
                    } else {
                        s.parentElement.classList.remove('has-text-warning');
                    }
                });
            });
            // On mouseover, set the color of the stars
            star.addEventListener('mouseover', (event) => {
                const value = parseInt(event.target.id);
                vendorReviewStars.forEach((s) => {
                    if (parseInt(s.id) <= value) {
                        s.parentElement.classList.add('has-text-warning');
                    } else {
                        s.parentElement.classList.remove('has-text-warning');
                    }
                });
            });
            // On mouseout, set the color of the stars
            star.addEventListener('mouseout', (event) => {
                vendorReviewStars.forEach((s) => {
                    if (parseInt(s.id) <= input.value) {
                        s.parentElement.classList.add('has-text-warning');
                    } else {
                        s.parentElement.classList.remove('has-text-warning');
                    }
                });
            });
        });
    }

    // Modals handler
    const modals = document.querySelectorAll('.modal');
    if (modals) {
        modals.forEach((modal) => {
            // Get the modal close button
            const modalCloseButtons = modal.querySelectorAll('.modal-close-btn');
            // Get the modal background
            const modalBackground = modal.querySelector('.modal-background');
            // Add event listener to the modal close button
            console.log(modalCloseButtons);
            modalCloseButtons.forEach((button) => {
                button.addEventListener('click', (event) => {
                    console.log('close button clicked');
                    modal.classList.remove('is-active');
                });
            });
            // Add event listener to the modal background
            modalBackground.addEventListener('click', (event) => {
                console.log('background clicked');
                modal.classList.remove('is-active');
            });
        });
    }

    // Specific buttons to open modals
    // Disable user model
    const disableUserModalButton = document.querySelector('#disable-user-modal-open-btn');
    if (disableUserModalButton) {
        // Make the button behave like an <a> tag
        // We do this to avoid making an actual <a> tag which causses redirection when we try to
        // open the modal
        // Make cursor a pointer
        disableUserModalButton.style.cursor = 'pointer';
        // Make the button look like a link (Blue text and no underline, remove blue text on hover)
        disableUserModalButton.classList.add('has-text-link', 'has-text-decoration-none');
        // Add event listener to the button
        disableUserModalButton.addEventListener('hover', (event) => {
            disableUserModalButton.classList.remove('has-text-link');
        });


        // ID of the modal is id of the button with -open-btn removed
        const disableUserModal = document.querySelector('#disable-user-modal');
        disableUserModalButton.addEventListener('click', (event) => {
            disableUserModal.classList.add('is-active');
        });
    }

    // Redirect user modal
    const redirectUserModalButton = document.querySelector('#redirect-user-modal-open-btn');
    if (redirectUserModalButton) {
        // Make the button behave like an <a> tag
        // We do this to avoid making an actual <a> tag which causses redirection when we try to
        // open the modal
        // Make cursor a pointer
        redirectUserModalButton.style.cursor = 'pointer';
        // Make the button look like a link (Blue text and no underline, remove blue text on hover)
        redirectUserModalButton.classList.add('has-text-link', 'has-text-decoration-none');
        // Add event listener to the button
        redirectUserModalButton.addEventListener('hover', (event) => {
            redirectUserModalButton.classList.remove('has-text-link');
        });

        // ID of the modal is id of the button with -open-btn removed
        const redirectUserModal = document.querySelector('#redirect-user-modal');
        redirectUserModalButton.addEventListener('click', (event) => {
            console.log('redirect user modal button clicked');
            redirectUserModal.classList.add('is-active');
        });
    }
});