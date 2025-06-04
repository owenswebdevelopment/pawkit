import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["searchButton", "mark"]

  async connect() {
    this.map = new google.maps.Map(document.getElementById("map"), {
      center: { lat: 35.633998, lng: 139.715653 },
      zoom: 13,
      mapId: "YOUR_MAP_ID"
    });

    window.googleMapsStimulusMapInstance = this.map;

    this.markers = [];

    const { AdvancedMarkerElement } = await google.maps.importLibrary("marker");
    this.AdvancedMarkerElement = AdvancedMarkerElement;

    this.markTarget.addEventListener("click", (event) => {
      if (event.target.closest(".save-location-btn")) {
        this.saveLocation(event);
      }
    });
  }

  search() {
    console.log("Search clicked 🚀");

    navigator.geolocation.getCurrentPosition(async (position) => {
      const userLat = position.coords.latitude;
      const userLng = position.coords.longitude;

      console.log(`User location: ${userLat}, ${userLng}`);

      const selectedCategories = Array.from(
        document.querySelectorAll('input[name="category"]:checked')
      ).map(cb => cb.value);

      if (selectedCategories.length === 0) {
        alert("Please select at least one category.");
        return;
      }

      this.clearMarkers();
      this.markTarget.innerHTML = "";

      for (const category of selectedCategories) {
        await this.nearbySearch(userLat, userLng, category);
      }
    });
  }

  async nearbySearch(lat, lng, category) {
    const { Place, SearchNearbyRankPreference } = await google.maps.importLibrary("places");

    const location = new google.maps.LatLng(lat, lng);
    const categoryType = this.getCategoryType(category);

    console.log(`Searching category: ${categoryType}`);

    const request = {
      fields: ["displayName", "location", "businessStatus", "id"],
      locationRestriction: {
        center: location,
        radius: 3000,
      },
      includedPrimaryTypes: [categoryType],
      maxResultCount: 10,
      rankPreference: SearchNearbyRankPreference.POPULARITY,
      language: "en",
      region: "jp",
    };

    const { places } = await Place.searchNearby(request);

    if (places.length) {
      console.log(`Found ${places.length} places for ${categoryType}`);

      const { LatLngBounds } = await google.maps.importLibrary("core");
      const bounds = new LatLngBounds();

      for (const place of places) {
        const pos = place.location.toJSON();

        const markerView = new this.AdvancedMarkerElement({
          map: this.map,
          position: pos,
          title: place.displayName,
        });

        this.markers.push(markerView);
        bounds.extend(pos);

        // Unique ID for card
        const cardId = `card-${place.id}`;

        const placeData = {
          place_id: place.id,
          name: place.displayName,
          latitude: pos.lat,
          longitude: pos.lng,
          business_status: place.businessStatus,
          rating: null,
          user_ratings_total: 0,
          first_review: null,
          category: category,
          address: "Unknown address",
          phone: "Unknown"
        };
 const cardHtml = `
  <div class="col">
    <div class="card mx-auto shadow-sm" style="max-width: 400px; width: 100%; cursor: pointer;">
      <div class="card-body d-flex justify-content-between flex-wrap">
        <div>
          <h5 class="card-title mb-2">${place.displayName}</h5>
          <span class="badge bg-primary mb-2">${category}</span>
          <p class="card-text rating-text text-muted">⭐ Rating: N/A (0 reviews)</p>
          <p class="card-text address-text text-muted">📍 Address: Unknown</p>
          <p class="card-text phone-text text-muted">☎️ Phone: Unknown</p>
          <button class="btn btn-outline-primary save-location-btn mt-2"
                  data-place='${encodeURIComponent(JSON.stringify(placeData))}'>
            Save Location
          </button>
        </div>
        <div class="mt-2 text-end">
          <i class="fa-solid fa-location-dot fa-xl text-danger"></i>
        </div>
      </div>
    </div>
  </div>
`;
        this.markTarget.insertAdjacentHTML("beforeend", cardHtml);

        // Now fetch details
        const { Place: PlaceLib } = await google.maps.importLibrary("places");

        try {
          const details = await PlaceLib.fetchFields({
            placeId: place.id,
            fields: [
              "formatted_address",
              "formatted_phone_number",
              "user_rating_count",
              "rating",
              "reviews"
            ],
            language: "en",
            region: "jp"
          });
  console.log(`Reviews for ${place.displayName}:`, details.reviews); // Debugging line
          placeData.rating = details.rating || null;
          placeData.user_ratings_total = details.user_rating_count || 0;
          placeData.first_review = details.reviews?.[0]?.text || null;
          placeData.address = details.formatted_address || "Unknown address";
          placeData.phone = details.formatted_phone_number || "Unknown";

          console.log(`Updated details for ${place.displayName}`, placeData);

          // 🚀 Update the card!
          const cardElement = document.getElementById(cardId);
          if (cardElement) {
            const ratingElement = cardElement.querySelector(".rating-text");
            const addressElement = cardElement.querySelector(".address-text");
            const phoneElement = cardElement.querySelector(".phone-text");

            if (ratingElement) {
              ratingElement.innerText = `Rating: ${placeData.rating || "N/A"} (${placeData.user_ratings_total || 0} reviews)`;
            }
            if (addressElement) {
              addressElement.innerText = `Address: ${placeData.address}`;
            }
            if (phoneElement) {
              phoneElement.innerText = `Phone: ${placeData.phone}`;
            }
          }

        } catch (error) {
          console.warn(`Could not fetch details for ${place.displayName}:`, error);
        }
      }

      this.map.fitBounds(bounds);

    } else {
      console.log(`No results found for category: ${category}`);
    }
  }

  saveLocation(event) {
    const button = event.target.closest(".save-location-btn");
    const encodedPlace = button.getAttribute("data-place");
    const placeData = JSON.parse(decodeURIComponent(encodedPlace));

    console.log("Saving place:", placeData);

    fetch("/locations", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      },
      body: JSON.stringify({ location: placeData })
    })
    .then(response => {
      if (response.ok) {
        console.log("Place saved successfully!");
        button.classList.remove("btn-outline-primary");
        button.classList.add("btn-success");
        button.innerText = "Saved!";
      } else {
        console.error("Failed to save place.");
      }
    });
  }

  clearMarkers() {
    console.log("Clearing markers...");
    this.markers.forEach(marker => {
      marker.map = null;
    });
    this.markers = [];
  }

 getCategoryType(category) {
  switch (category) {
    case "Vet":
      return "veterinary_care";
    case "Petshop":
      return "pet_store";
    case "park":
      return "park";
    case "petcafe":
      return "cafe";
    default:
      return "pet_store";
  }
}
}
